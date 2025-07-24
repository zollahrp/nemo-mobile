import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/jadwal_model.dart';
import 'package:intl/intl.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  List<JadwalModel> jadwalList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJadwalNotifikasi();
  }

  Future<void> fetchJadwalNotifikasi() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    final response = await Supabase.instance.client
        .from('jadwal')
        .select()
        .gte('tanggal', today) // Ambil jadwal dari hari ini ke depan
        .order('tanggal', ascending: true);

    setState(() {
      jadwalList = response.map<JadwalModel>((item) => JadwalModel.fromMap(item)).toList();
      isLoading = false;
    });
  }

  String generateJudul(String type) {
    return type == 'makan'
        ? 'Waktunya Memberi Makan!'
        : 'Maintenance Filter';
  }

  String generateDeskripsi(String type, String akuariumId) {
    return type == 'makan'
        ? 'Ikan di akuarium $akuariumId menunggu makananmu 🍽️'
        : 'Sudah waktunya membersihkan filter akuarium $akuariumId 🧼';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : jadwalList.isEmpty
        ? const Center(child: Text('Belum ada notifikasi'))
        : Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[50],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Geser notifikasi ke kiri untuk menghapus.',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jadwalList.length,
                  itemBuilder: (context, index) {
                    final jadwal = jadwalList[index];

                    return Dismissible(
                      key: Key(jadwal.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await Supabase.instance.client
                            .from('jadwal')
                            .delete()
                            .eq('id', jadwal.id);

                        setState(() {
                          jadwalList.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifikasi dihapus')),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active_outlined, color: Colors.blue),
                        title: Text(generateJudul(jadwal.type)),
                        subtitle: Text(generateDeskripsi(jadwal.type, jadwal.akuariumId)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
    );  
  }
}
