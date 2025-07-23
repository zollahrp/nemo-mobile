import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/akuarium_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailAkuariumScreen extends StatelessWidget {
  final AkuariumModel akuarium;

  const DetailAkuariumScreen({super.key, required this.akuarium});

  Future<List<Map<String, dynamic>>> fetchIkanAkuarium() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('akuarium_ikan')
        .select('ikan(id, nama, gambar_url)')
        .eq('akuarium_id', akuarium.id);

    return response;
  }

  Future<String?> getSuhuRange() async {
    final supabase = Supabase.instance.client;

    final result = await supabase
        .from('akuarium_ikan')
        .select('ikan(temp_min, temp_max)')
        .eq('akuarium_id', akuarium.id);

    if (result.isEmpty) return null;

    final temps = result.map((e) => e['ikan']).toList();

    final minTemp = temps.map((e) => (e['temp_min'] as num).toDouble()).reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.map((e) => (e['temp_max'] as num).toDouble()).reduce((a, b) => a > b ? a : b);

    return "${minTemp.toStringAsFixed(1)}°C - ${maxTemp.toStringAsFixed(1)}°C";
  }

  Future<int> fetchJumlahIkan() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('akuarium_ikan')
        .select('jumlah')
        .eq('akuarium_id', akuarium.id) as List<dynamic>;

    if (response.isEmpty) return 0;

    final total = response.fold<int>(0, (prev, e) {
      final jumlah = (e['jumlah'] ?? 0) as int;
      return prev + jumlah;
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIkanList(), // 1. daftar ikan
                  
                  const SizedBox(height: 20),
                  _buildSummaryGrid(), // 2. ringkasan ekosistem di bawah ikan list

                  if (!akuarium.isSetMode) ...[
                    const SizedBox(height: 20),
                    _buildWarning(), // 3. warning mode manual
                  ],

                  const SizedBox(height: 20),
                  _buildQuickTips(), // 4. tips tambahan
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIkanList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchIkanAkuarium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("Gagal memuat ikan");
        }

        final ikanList = snapshot.data!;

        if (ikanList.isEmpty) {
          return const Text("Belum ada ikan di akuarium ini.");
        }

        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ikanList.length,
            itemBuilder: (context, index) {
              final ikan = ikanList[index]['ikan'];

              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        ikan['gambar_url'] ?? '',
                        height: 80,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          width: 120,
                          color: Colors.blue.shade50,
                          child: const Icon(Icons.pets, size: 30, color: Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        ikan['nama'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 32, color: Colors.red),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Kecocokan Ikan",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 4),
                Text(
                  "Ikan 1 dan Ikan 2 tidak cocok di dalam satu akuarium karena Ikan 1 merupakan ikan karnivora.",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    return FutureBuilder<String?>(
      future: getSuhuRange(),
      builder: (context, snapshot) {
        String suhuTip;
        if (snapshot.connectionState == ConnectionState.waiting) {
          suhuTip = "Mengambil data suhu ikan...";
        } else if (snapshot.hasError || !snapshot.hasData) {
          suhuTip = "Gagal memuat data suhu ikan.";
        } else {
          suhuTip = "Suhu ideal untuk ikan di akuarium ini adalah ${snapshot.data}.";
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quick Tips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _tipCard(Icons.thermostat, suhuTip),
            const SizedBox(height: 12),
            _tipCard(Icons.build_circle_rounded, "Lakukan maintenance (ganti air) minimal 1x sebulan."),
            const SizedBox(height: 12),
            _tipCard(Icons.restaurant_menu_rounded, "Pakan diberikan 2x sehari dengan jeda 10-12 jam."),
          ],
        );
      },
    );
  }

 Widget _buildSummaryGrid() {
  List<Widget> items = [];

  if (akuarium.tankSizeL != null) {
    items.add(_summaryItem("🧪", "${akuarium.tankSizeL!.toStringAsFixed(0)} L"));
  }

  if (akuarium.temperature != null) {
    items.add(_summaryItem("🌡️", "${akuarium.temperature!.toStringAsFixed(1)}°C"));
  }

  if (akuarium.ph != null) {
    items.add(_summaryItem("⚗️", "pH ${akuarium.ph!.toStringAsFixed(1)}"));
  }

  items.add(
    FutureBuilder<int>(
      future: fetchJumlahIkan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _summaryItem("🐠", "Memuat...");
        } else if (snapshot.hasError || !snapshot.hasData) {
          return _summaryItem("🐠", "Gagal");
        } else {
          return _summaryItem("🐠", "${snapshot.data} Ekor");
        }
      },
    ),
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Ekosistem Akuarium 🧬",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
        children: items,
      ),
    ],
  );
}


Widget _summaryItem(String emoji, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F9), // soft blue-gray bg
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

  Widget _tipCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _tipItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade400),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  TextStyle _infoStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2FE),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 35, bottom: 20, left: 20, right: 20),
      child: Stack(
        children: [
          Positioned(
            bottom: -10,
            left: -10,
            child: Image.asset('lib/assets/images/top1.png', height: 90),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Image.asset('lib/assets/images/top2.png', height: 90),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {
                      // TODO: Add menu action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  akuarium.fotoUrl != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(akuarium.fotoUrl!),
                          backgroundColor: Colors.grey.shade200,
                        )
                      : const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('lib/assets/images/avatar_akuarium.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          akuarium.nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Detail lengkap dari akuarium kamu",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: akuarium.isSetMode ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  akuarium.isSetMode ? "Dibuat dengan set ekosistem yang direkomendasikan" : "Dibuat dengan mode manual",
                  style: TextStyle(
                    color: akuarium.isSetMode ? Colors.green[800] : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}