import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetEcosystemScreen extends StatefulWidget {
  const SetEcosystemScreen({super.key});

  @override
  State<SetEcosystemScreen> createState() => _SetEcosystemScreenState();
}

class _SetEcosystemScreenState extends State<SetEcosystemScreen> {
  String? selectedFish;
  double selectedTemp = 26.0;
  double selectedPh = 7.0;
  int tankSize = 50;
  String resultMessage = '';

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
          .select('id, nama, temp_min, temp_max, ph_min, ph_max');

      setState(() {
        fishData = List<Map<String, dynamic>>.from(response);
        fishList = fishData.map((f) => f['nama'] as String).toList();
      });
    } catch (e) {
      print('⚠️ Gagal fetch data ikan: $e');
    }
  }

  void checkCompatibility() {
    final fish = fishData.firstWhere(
      (f) => f['nama'] == selectedFish,
      orElse: () => {},
    );

    if (fish.isEmpty) {
      setState(() => resultMessage = '❌ Ikan tidak ditemukan.');
      return;
    }

    final tempMin = fish['temp_min'];
    final tempMax = fish['temp_max'];
    final phMin = fish['ph_min'];
    final phMax = fish['ph_max'];

    if (selectedTemp < tempMin ||
        selectedTemp > tempMax ||
        selectedPh < phMin ||
        selectedPh > phMax) {
      setState(() => resultMessage = '⚠️ Parameter tidak cocok untuk ikan ${fish['nama']}.');
    } else {
      setState(() => resultMessage = '✅ Parameter cocok dengan ${fish['nama']}.');
    }
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
      final fish = fishData.firstWhere((f) => f['nama'] == selectedFish);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ User tidak ditemukan')),
        );
        return;
      }

      await Supabase.instance.client.from('ecosystems').insert({
        'profiles_id': userId,
        'ikan_id': fish['id'],
        'temperature': selectedTemp,
        'ph': selectedPh,
        'tank_size_l': tankSize,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Ekosistem berhasil disimpan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Ekosistem Akuarium')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: fishList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Ikan:', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: selectedFish,
                    hint: const Text('Pilih ikan'),
                    isExpanded: true,
                    items: fishList.map((String fish) {
                      return DropdownMenuItem(value: fish, child: Text(fish));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedFish = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  Text('Suhu Ideal: ${selectedTemp.toStringAsFixed(1)}°C'),
                  Slider(
                    value: selectedTemp,
                    min: 20,
                    max: 34,
                    divisions: 14,
                    label: '${selectedTemp.toStringAsFixed(1)}°C',
                    onChanged: (value) => setState(() => selectedTemp = value),
                  ),
                  const SizedBox(height: 8),

                  Text('pH Ideal: ${selectedPh.toStringAsFixed(1)}'),
                  Slider(
                    value: selectedPh,
                    min: 4,
                    max: 9,
                    divisions: 10,
                    label: selectedPh.toStringAsFixed(1),
                    onChanged: (value) => setState(() => selectedPh = value),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    initialValue: tankSize.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Ukuran Akuarium (liter)'),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) setState(() => tankSize = parsed);
                    },
                  ),
                  const SizedBox(height: 16),

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
                    Text(
                      resultMessage,
                      style: const TextStyle(fontSize: 16),
                    ),

                  const Spacer(),

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
