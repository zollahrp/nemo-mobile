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
  double recommendedTempMin = 26.0;
  double recommendedTempMax = 26.0;
  double recommendedPhMin = 7.0;
  double recommendedPhMax = 7.0;
  int tankSize = 50;
  String resultMessage = '';
  bool isCompatible = false;

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

  void calculateRecommendedParameters() {
    if (selectedFishes.isEmpty) {
      setState(() {
        recommendedTempMin = 26.0;
        recommendedTempMax = 26.0;
        recommendedPhMin = 7.0;
        recommendedPhMax = 7.0;
      });
      return;
    }

    double tempMinOverall = double.negativeInfinity;
    double tempMaxOverall = double.infinity;
    double phMinOverall = double.negativeInfinity;
    double phMaxOverall = double.infinity;

    for (var item in selectedFishes) {
      final namaIkan = (item['nama'] as String?)?.split(' (').first ?? '';
      final fish = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan);
      
      if (fish != null) {
        final tempMin = double.tryParse(fish['temp_min'].toString()) ?? 0;
        final tempMax = double.tryParse(fish['temp_max'].toString()) ?? 100;
        final phMin = double.tryParse(fish['ph_min'].toString()) ?? 0;
        final phMax = double.tryParse(fish['ph_max'].toString()) ?? 14;

        tempMinOverall = tempMinOverall == double.negativeInfinity ? tempMin : 
                        tempMin > tempMinOverall ? tempMin : tempMinOverall;
        tempMaxOverall = tempMaxOverall == double.infinity ? tempMax : 
                        tempMax < tempMaxOverall ? tempMax : tempMaxOverall;
        phMinOverall = phMinOverall == double.negativeInfinity ? phMin : 
                      phMin > phMinOverall ? phMin : phMinOverall;
        phMaxOverall = phMaxOverall == double.infinity ? phMax : 
                      phMax < phMaxOverall ? phMax : phMaxOverall;
      }
    }

    setState(() {
      recommendedTempMin = tempMinOverall == double.negativeInfinity ? 26.0 : tempMinOverall;
      recommendedTempMax = tempMaxOverall == double.infinity ? 26.0 : tempMaxOverall;
      recommendedPhMin = phMinOverall == double.negativeInfinity ? 7.0 : phMinOverall;
      recommendedPhMax = phMaxOverall == double.infinity ? 7.0 : phMaxOverall;
    });
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
        totalSize += 10.0 * (item['jumlah'] ?? 1);
      }
    }

    setState(() => tankSize = totalSize.round());
  }

  void checkCompatibility() {
    List<String> incompatibleFishes = [];
    bool tempCompatible = true;
    bool phCompatible = true;

    // Check temperature and pH compatibility
    for (int i = 0; i < selectedFishes.length; i++) {
      for (int j = i + 1; j < selectedFishes.length; j++) {
        final namaIkan1 = (selectedFishes[i]['nama'] as String?)?.split(' (').first ?? '';
        final namaIkan2 = (selectedFishes[j]['nama'] as String?)?.split(' (').first ?? '';
        
        final fish1 = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan1);
        final fish2 = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan2);

        if (fish1 != null && fish2 != null) {
          final temp1Min = double.tryParse(fish1['temp_min'].toString()) ?? 0;
          final temp1Max = double.tryParse(fish1['temp_max'].toString()) ?? 100;
          final temp2Min = double.tryParse(fish2['temp_min'].toString()) ?? 0;
          final temp2Max = double.tryParse(fish2['temp_max'].toString()) ?? 100;

          final ph1Min = double.tryParse(fish1['ph_min'].toString()) ?? 0;
          final ph1Max = double.tryParse(fish1['ph_max'].toString()) ?? 14;
          final ph2Min = double.tryParse(fish2['ph_min'].toString()) ?? 0;
          final ph2Max = double.tryParse(fish2['ph_max'].toString()) ?? 14;

          // Check temperature overlap
          if (temp1Max < temp2Min || temp2Max < temp1Min) {
            tempCompatible = false;
            incompatibleFishes.add(
              '🌡️ ${fish1['nama']} (${temp1Min}-${temp1Max}°C) tidak kompatibel dengan ${fish2['nama']} (${temp2Min}-${temp2Max}°C)'
            );
          }

          // Check pH overlap
          if (ph1Max < ph2Min || ph2Max < ph1Min) {
            phCompatible = false;
            incompatibleFishes.add(
              '⚗️ ${fish1['nama']} (pH ${ph1Min}-${ph1Max}) tidak kompatibel dengan ${fish2['nama']} (pH ${ph2Min}-${ph2Max})'
            );
          }
        }
      }
    }

    // Check if recommended range is valid
    if (recommendedTempMin > recommendedTempMax) {
      tempCompatible = false;
      incompatibleFishes.add('❌ Tidak ada rentang suhu yang cocok untuk semua ikan');
    }

    if (recommendedPhMin > recommendedPhMax) {
      phCompatible = false;
      incompatibleFishes.add('❌ Tidak ada rentang pH yang cocok untuk semua ikan');
    }

    setState(() {
      isCompatible = incompatibleFishes.isEmpty && tempCompatible && phCompatible;
      resultMessage = isCompatible
          ? '✅ Semua ikan kompatibel!\n🌡️ Suhu: ${recommendedTempMin.toStringAsFixed(1)}-${recommendedTempMax.toStringAsFixed(1)}°C\n⚗️ pH: ${recommendedPhMin.toStringAsFixed(1)}-${recommendedPhMax.toStringAsFixed(1)}'
          : incompatibleFishes.join('\n');
    });
  }

  void resetForm() {
    setState(() {
      selectedFishes.clear();
      selectedFish = null;
      recommendedTempMin = 26.0;
      recommendedTempMax = 26.0;
      recommendedPhMin = 7.0;
      recommendedPhMax = 7.0;
      tankSize = 50;
      resultMessage = '';
      isCompatible = false;
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

      if (!isCompatible) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Silakan cek kompatibilitas terlebih dahulu')),
        );
        return;
      }

      // Prepare fish names array
      List<String> ikanNames = [];
      for (var item in selectedFishes) {
        final namaIkan = (item['nama'] as String?)?.split(' (').first ?? '';
        final jumlah = item['jumlah'] ?? 1;
        for (int i = 0; i < jumlah; i++) {
          ikanNames.add(namaIkan);
        }
      }

      final temperature = (recommendedTempMin + recommendedTempMax) / 2;
      final ph = (recommendedPhMin + recommendedPhMax) / 2;

      final response = await Supabase.instance.client.from('akuarium').insert({
        'profiles_id': userId,
        'nama': 'Akuarium Baru',
        'temperature': temperature,
        'ph': ph,
        'tank_size_l': tankSize,
        'jadwal_pakan': '',
        'jadwal_maintenance': '',
        'is_favorite': false,
        'is_set_mode': true,
      }).select();

      if (response == null || response.isEmpty) {
        throw Exception('❌ Insert gagal. Tidak ada data dikembalikan.');
      }

      final akuariumId = response.first['id'];

      for (var item in selectedFishes) {
        final namaIkan = (item['nama'] as String?)?.split(' (').first ?? '';
        final jumlah = item['jumlah'] ?? 1;
        final ikan = fishData.firstWhereOrNull((f) => f['nama'] == namaIkan);
        final ikanId = ikan?['id'];

        if (ikanId != null) {
          await Supabase.instance.client.from('akuarium_ikan').insert({
            'akuarium_id': akuariumId,
            'ikan_id': ikanId,
            'jumlah': jumlah,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Akuarium berhasil disimpan')),
      );

      resetForm();

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
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

    if (kelompokAir.contains(kategori1) && kelompokAir.contains(kategori2)) {
      return kategori1 == kategori2;
    }

    if (kategori1 == predator || kategori2 == predator) {
      return kategori1 == kategori2;
    }

    if ((kategori1 == invertebrata && kategori2 == predator) ||
        (kategori2 == invertebrata && kategori1 == predator)) {
      return false;
    }

    return true;
  }

  bool isCompatibleWithAll(String kategoriBaru) {
    for (var item in selectedFishes) {
      final ikan = fishData.firstWhereOrNull((f) => f['nama'] == item['nama']);
      if (ikan == null) continue;

      final kategoriLama = ikan['kategori'];
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
                              selectedItem: item['nama'] != null ? "${item['nama']} (${fishData.firstWhereOrNull((f) => f['nama'] == item['nama'])?['kategori'] ?? ''})" : null,
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
                                  calculateRecommendedParameters();
                                  isCompatible = false; // Reset compatibility status
                                  resultMessage = ''; // Clear previous results
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
                                    isCompatible = false; // Reset compatibility status
                                    resultMessage = ''; // Clear previous results
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
                                    calculateRecommendedParameters();
                                    isCompatible = false; // Reset compatibility status
                                    resultMessage = ''; // Clear previous results
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
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Parameter Rekomendasi:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('🌡️ Suhu: ${recommendedTempMin.toStringAsFixed(1)}-${recommendedTempMax.toStringAsFixed(1)}°C'),
                          Text('⚗️ pH: ${recommendedPhMin.toStringAsFixed(1)}-${recommendedPhMax.toStringAsFixed(1)}'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: selectedFishes.isNotEmpty ? checkCompatibility : null,
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
                      color: isCompatible ? Colors.green[50] : Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          resultMessage,
                          style: TextStyle(
                            color: isCompatible ? Colors.green[700] : Colors.red[700],
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
                  if (isCompatible)
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