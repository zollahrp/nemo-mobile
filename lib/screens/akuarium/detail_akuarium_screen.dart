import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/akuarium_model.dart';
import 'package:nemo_mobile/screens/akuarium/atur_jadwal_screen.dart';
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

 Future<List<Map<String, dynamic>>> fetchJadwalAkuarium() async {
  final supabase = Supabase.instance.client;
  final now = DateTime.now();

  final response = await supabase
      .from('jadwal')
      .select()
      .eq('akuarium_id', akuarium.id)
      .order('tanggal', ascending: true);

  final List<Map<String, dynamic>> jadwalList = List<Map<String, dynamic>>.from(response);

  final filtered = jadwalList.where((jadwal) {
    final tanggalStr = jadwal['tanggal'];
    final jamStr = jadwal['jam'];

    if (tanggalStr == null || jamStr == null) return false;

    try {
      final jamParts = jamStr.split(':');
      final jam = jamParts[0].padLeft(2, '0');
      final menit = jamParts[1].padLeft(2, '0');
      final fullDateTime = DateTime.parse('$tanggalStr $jam:$menit:00');

      print('fullDateTime: $fullDateTime');
      print('now: $now');

      return fullDateTime.isAfter(now.subtract(const Duration(minutes: 1)));
    } catch (e) {
      print('Error parsing tanggal/jam: $e');
      return false;
    }
  }).toList();

  return filtered;
}

  Future<void> updateJadwalPakan({
    required String akuariumId,
    required String jadwal,
  }) async {
    final now = DateTime.now().toIso8601String();

    try {
      final response = await Supabase.instance.client
          .from('akuarium')
          .update({
            'jadwal_pakan': jadwal,
            'last_fed_time': now,
          })
          .eq('id', akuariumId);

      debugPrint('✅ Jadwal pakan berhasil diupdate');
    } catch (e) {
      debugPrint('❌ Gagal update jadwal pakan: $e');
    }
  }

  Future<void> updateJadwalMaintenance({
    required String akuariumId,
    required String jadwal,
  }) async {
    final now = DateTime.now().toIso8601String();

    try {
      final response = await Supabase.instance.client
          .from('akuarium')
          .update({
            'jadwal_maintenance': jadwal,
            'last_maintenance_time': now,
          })
          .eq('id', akuariumId);

      debugPrint('✅ Jadwal maintenance berhasil diupdate');
    } catch (e) {
      debugPrint('❌ Gagal update jadwal maintenance: $e');
    }
  }


  

  Future<String?> getSuhuRange() async {
    final supabase = Supabase.instance.client;

    final result = await supabase
        .from('akuarium_ikan')
        .select('ikan(temp_min, temp_max)')
        .eq('akuarium_id', akuarium.id);

    if (result.isEmpty) return null;

    final temps = result.map((e) => e['ikan']).toList();

    final minTemp = temps.map((e) => (e['temp_min'] as num).toDouble()).reduce((a, b) => a < b ? a : b) ;
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

    void _showTambahIkanDialog(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final katalog = await supabase.from('ikan').select('id, nama, gambar_url');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: katalog.length,
          itemBuilder: (context, index) {
            final ikan = katalog[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ikan['gambar_url'] ?? ''),
                backgroundColor: Colors.blue.shade50,
              ),
              title: Text(ikan['nama']),
              onTap: () {
                Navigator.pop(context);
                _konfirmasiTambah(context, ikan['id'], ikan['nama']);
              },
            );
          },
        );
      },
    );
  }

  void _konfirmasiTambah(BuildContext context, String ikanId, String namaIkan) async {
    final jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah $namaIkan"),
          content: TextField(
            controller: jumlahController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Jumlah"),
          ),
          actions: [
            TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AturJadwalScreen(
                    type: 'makan',
                    akuariumId: akuarium.id,
                  ),
                ),
              );
            },
            child: const Text('Atur Jadwal Makan'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AturJadwalScreen(
                    type: 'maintenance',
                    akuariumId: akuarium.id,
                  ),
                ),
              );
            },
            child: const Text('Atur Jadwal Maintenance'),
          ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () async {
                final supabase = Supabase.instance.client;
                final jumlah = int.tryParse(jumlahController.text) ?? 1;

                await supabase.from('akuarium_ikan').insert({
                  'akuarium_id': akuarium.id,
                  'ikan_id': ikanId,
                  'jumlah': jumlah,
                });

                Navigator.pop(context, true);
                // Trigger refresh
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        );
      },
    );
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
                _buildIkanList(),

                const SizedBox(height: 20),
                _buildSummaryGrid(),

                if (!akuarium.isSetMode) ...[
                  const SizedBox(height: 20),
                  _buildWarning(),
                ],

                const SizedBox(height: 20),
                _buildQuickTips(),

                const SizedBox(height: 20),
                _buildReminderCards(context),

                // ⬇️ Tambahkan bagian Jadwal di sini
                const SizedBox(height: 20),
                const Text(
                  "Jadwal Pemeliharaan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildJadwalList(),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: ikanList.isEmpty
                  ? const Center(child: Text("Belum ada ikan di akuarium ini."))
                  : ListView.builder(
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
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: akuarium.isSetMode
                  ? () => _showTambahIkanDialog(context)
                  : null,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Ikan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJadwalList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchJadwalAkuarium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Belum ada jadwal.");
        }

        final jadwalList = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: jadwalList.map((jadwal) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${jadwal['type']} - ${jadwal['tanggal']} ${jadwal['jam']}"),
                  const Icon(Icons.schedule, color: Colors.blue),
                ],
              ),
            );
          }).toList(),
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
            const Text("Quick Tips", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        "Ekosistem Akuarium",
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

  Widget _emptyReminderCard({
    required String title,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38ABF8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

    Widget _buildReminderCards(BuildContext context) {
    if (akuarium.lastFedTime == null || akuarium.lastMaintenanceTime == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reminder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _emptyReminderCard(
            title: "Pemberian Makan",
            buttonLabel: "Atur Jadwal",
            icon: Icons.restaurant_menu,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AturJadwalScreen(
                    type: 'makan',
                    akuariumId: akuarium.id,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          _emptyReminderCard(
            title: "Maintenance Aquarium",
            buttonLabel: "Atur Jadwal",
            icon: Icons.build_circle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AturJadwalScreen(
                    type: 'maintenance',
                    akuariumId: akuarium.id,
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    // Kalau udah ada datanya (seperti sebelumnya)
    DateTime now = DateTime.now();
    DateTime makanNext = akuarium.lastFedTime!.add(Duration(hours: 12));
    DateTime maintenanceNext = akuarium.lastMaintenanceTime!.add(Duration(days: 30));

    Duration remainingMakan = makanNext.difference(now);
    Duration remainingMaintenance = maintenanceNext.difference(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reminder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _reminderCard("Pemberian Makan", remainingMakan),
        const SizedBox(height: 12),
        _reminderCard("Maintenance Aquarium", remainingMaintenance),
      ],
    );
  }

  Widget _reminderCard(String title, Duration remaining) {
    String timeText;

    if (remaining.inDays > 0) {
      timeText = "${remaining.inDays} days remaining...";
    } else if (remaining.inHours > 0) {
      timeText = "${remaining.inHours} hours remaining...";
    } else if (remaining.inMinutes > 0) {
      timeText = "${remaining.inMinutes} minutes remaining...";
    } else {
      timeText = "Segera dilakukan!";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Title & Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Bell Icon
          const Icon(
            Icons.notifications_active_rounded,
            color: Color(0xFF38ABF8),
            size: 28,
          ),
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