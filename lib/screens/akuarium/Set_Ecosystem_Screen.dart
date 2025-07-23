import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SetEcosystemScreen extends StatefulWidget {
  const SetEcosystemScreen({super.key});

  @override
  State<SetEcosystemScreen> createState() => _SetEcosystemScreenState();
}

class _SetEcosystemScreenState extends State<SetEcosystemScreen> {
  List<Map<String, dynamic>> selectedFishes = []; 
  String? selectedFish;
  double selectedTemp = 26.0;
  double selectedPh = 7.0;
  int tankSize = 50;
  String resultMessage = '';
  int fishCount = 1;

  List<Map<String, dynamic>> fishData = [];
  List<String> fishList = [];

  @override
  void initState() {
    super.initState();
    fetchFishList();
  }

  Future<void> fetchFishList() async {
    try {
      final response = await Supabase.instance.client
          .from('ikan')
          .select('id, nama, ukuran, temp_min, temp_max, ph_min, ph_max, kategori');

      setState(() {
        fishData = List<Map<String, dynamic>>.from(response);
        fishList = fishData.map((f) => f['nama'] as String).toSet().toList(); 
      });
    } catch (e) {
      print('⚠️ Gagal fetch data ikan: $e');
    }
  }

  void calculateTotalTankSize() {
    double totalSize = 0;

    for (var item in selectedFishes) {
      final namaIkan = (item['nama'] as String?)?.split(' (').first ?? '';
      final fish = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan);

      if (fish != null) {
        final ukuranStr = fish['ukuran'] ?? '5';
        final double length = double.tryParse(
              ukuranStr.toString().replaceAll(RegExp(r'[^0-9.]'), ''),
            ) ??
            5.0;
        totalSize += length * (item['jumlah'] ?? 1) * 2;
      } else {
        // fallback kalau ikan gak ketemu
        totalSize += 10.0 * (item['jumlah'] ?? 1); // misal pakai default 10L
      }
    }

    setState(() => tankSize = totalSize.round());
  }


  void checkCompatibility() {
    List<String> incompatibleFishes = [];

    for (var item in selectedFishes) {
      final namaIkan = (item['nama'] as String?)?.split(' (').first ?? '';
      final fish = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan);
      if (fish == null) {
        incompatibleFishes.add('❌ ${item['nama'] ?? 'Unknown'} (data tidak ditemukan)');
        continue;
      }

      final tempMin = double.tryParse(fish['temp_min'].toString()) ?? 0;
      final tempMax = double.tryParse(fish['temp_max'].toString()) ?? 100;
      final phMin = double.tryParse(fish['ph_min'].toString()) ?? 0;
      final phMax = double.tryParse(fish['ph_max'].toString()) ?? 14;

      if (selectedTemp < tempMin || selectedTemp > tempMax || selectedPh < phMin || selectedPh > phMax) {
        incompatibleFishes.add(
          '⚠️ ${fish['nama']} butuh suhu $tempMin–$tempMax°C dan pH $phMin–$phMax',
        );
      }
    }

    setState(() {
      resultMessage = incompatibleFishes.isEmpty
          ? '✅ Semua ikan cocok dengan parameter yang dipilih.'
          : incompatibleFishes.join('\n');
    });
  }

  void resetForm() {
    setState(() {
      selectedFish = null;
      selectedTemp = 26.0;
      selectedPh = 7.0;
      tankSize = 50;
      resultMessage = '';
    });
  }

    Future<void> saveEcosystem() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ User tidak ditemukan')),
        );
        return;
      }

      // ✅ Validasi kategori sebelum simpan
      if (!selectedFishes.every((item) {
        final kategori = fishData.firstWhereOrNull((f) => f['nama'] == item['nama'])?['kategori'];
        return isCompatibleWithAll(kategori ?? '');
      })) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Ada ikan yang tidak cocok dalam akuarium')),
        );
        return;
      }

      for (var item in selectedFishes) {
        final fish = fishData.firstWhereOrNull((f) => f['nama'] == item['nama']);
        if (fish == null) continue;

        await Supabase.instance.client.from('ecosystems').insert({
          'profiles_id': userId,
          'ikan_id': fish['id'],
          'jumlah': item['jumlah'],
          'temperature': selectedTemp,
          'ph': selectedPh,
          'tank_size_l': tankSize,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Ekosistem berhasil disimpan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan: $e')),
      );
    }
  }

  bool areIkanCompatible(String kategori1, String kategori2) {
    if (kategori1 == kategori2) return true;

    final kelompokAir = ['Ikan Air Tawar', 'Ikan Air Payau', 'Ikan Laut', 'Ikan Air Dingin'];
    final predator = 'Ikan Predator';
    final invertebrata = 'Invertabrata';

    // Tidak bisa gabung jika habitat air beda (contoh: air tawar vs laut)
    if (kelompokAir.contains(kategori1) && kelompokAir.contains(kategori2)) {
      // Tapi kalau beda jenis air (misal Tawar vs Laut), tetap gak boleh
      return kategori1 == kategori2;
    }

    // Predator tidak boleh digabung dengan apa pun selain sesama predator
    if (kategori1 == predator || kategori2 == predator) {
      return kategori1 == kategori2;
    }

    // Invertabrata tidak bisa dicampur dengan predator
    if ((kategori1 == invertebrata && kategori2 == predator) ||
        (kategori2 == invertebrata && kategori1 == predator)) {
      return false;
    }
    print("cek: $kategori1 vs $kategori2 => ${kategori1 == kategori2}");

    return true;
  }

  bool isCompatibleWithAll(String kategoriBaru) {
    for (var item in selectedFishes) {
      final ikan = fishData.firstWhereOrNull((f) => f['nama'] == item['nama']);
      if (ikan == null) continue;

      final kategoriLama = ikan['kategori']; // pastikan field ini ada di tabel ikan
      if (kategoriLama != null && !areIkanCompatible(kategoriBaru, kategoriLama)) {
        return false;
      }
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Set Ekosistem Akuarium')),
      body: fishList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ikan & Jumlah:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ...selectedFishes.map((item) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownSearch<String>(
                              popupProps: const PopupProps.menu(showSearchBox: true),
                              items: fishList.map((namaIkan) {
                                final ikan = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan);
                                final kategori = ikan?['kategori'] ?? '';
                                return "$namaIkan ($kategori)";
                              }).toList(),
                              selectedItem: item['nama'],
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Pilih Ikan",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              onChanged: (value) {
                                final namaBaru = value?.split(' (').first;
                                final selectedFishData = fishData.firstWhereOrNull((f) => f['nama'] == namaBaru);
                                final kategoriBaru = selectedFishData?['kategori'];

                                if (kategoriBaru != null && !isCompatibleWithAll(kategoriBaru)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.warning_amber_rounded, color: Colors.white),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Ikan kategori "$kategoriBaru" tidak cocok dengan ikan lain di akuarium.',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  item['nama'] = namaBaru;
                                  selectedFish = namaBaru;
                                  calculateTotalTankSize();
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: item['jumlah'].toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Jumlah',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val) {
                                final parsed = int.tryParse(val);
                                if (parsed != null) {
                                  setState(() {
                                    item['jumlah'] = parsed;
                                    calculateTotalTankSize();
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedFishes.remove(item);
                                    calculateTotalTankSize();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 4),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFishes.add({'nama': null, 'jumlah': 1});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Ikan ke Akuarium'),
                  ),

                  const SizedBox(height: 24),
                  Text('Suhu (°C): ${selectedTemp.toStringAsFixed(1)}'),
                  Slider(
                    value: selectedTemp,
                    min: 10,
                    max: 40,
                    divisions: 60,
                    label: selectedTemp.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => selectedTemp = value);
                    },
                  ),

                  const SizedBox(height: 8),
                  Text('pH: ${selectedPh.toStringAsFixed(1)}'),
                  Slider(
                    value: selectedPh,
                    min: 4,
                    max: 9,
                    divisions: 50,
                    label: selectedPh.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => selectedPh = value);
                    },
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: checkCompatibility,
                        icon: const Icon(Icons.search),
                        label: const Text('Cek Kesesuaian'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: resetForm,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  if (resultMessage.isNotEmpty)
                    Card(
                      color: resultMessage.contains('✅') ? Colors.green[50] : Colors.amber[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          resultMessage,
                          style: TextStyle(
                            color: resultMessage.contains('✅') ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  Text(
                    'Ukuran Akuarium yang Dibutuhkan: $tankSize Liter',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (tankSize / 500).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                    minHeight: 8,
                  ),

                  const SizedBox(height: 24),
                  if (resultMessage.contains('✅'))
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: saveEcosystem,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan ke Akuarium'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}