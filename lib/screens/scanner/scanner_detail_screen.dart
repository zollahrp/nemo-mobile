import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/penyakit_model.dart';

class ScannerDetailScreen extends StatefulWidget {
  final String jenisIkan;
  final String status;

  const ScannerDetailScreen({
    super.key,
    required this.jenisIkan,
    required this.status,
  });

  @override
  State<ScannerDetailScreen> createState() => _ScannerDetailScreenState();
}

class _ScannerDetailScreenState extends State<ScannerDetailScreen> {
  Map<String, dynamic>? ikan;
  List<PenyakitModel> penyakitList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIkan(); // Ini langsung handle semuanya
  }

  Future<void> fetchIkan() async {
    final response = await Supabase.instance.client
        .from('ikan')
        .select()
        .eq('nama', widget.jenisIkan)
        .maybeSingle();

    setState(() {
      ikan = response;
      isLoading = false;
    });

    // Fetch penyakit kalau tidak sehat
    if (ikan != null && widget.status.toLowerCase() != 'sehat') {
      final res = await Supabase.instance.client
          .from('ikan_penyakit')
          .select('penyakit(*)')
          .eq('ikan_id', ikan!['id']);

      setState(() {
        penyakitList = (res as List)
            .map((row) => PenyakitModel.fromMap(row['penyakit']))
            .toList();
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Scan"),
        backgroundColor: const Color(0xFF45B1F9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ikan == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/not_found.png', // kamu bisa ganti sesuai asset yg kamu punya
                      width: 160,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Ikan tidak dikenali",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Yuk coba lagi dengan gambar yang lebih jelas\natau pastikan ikan kamu termasuk yang dikenal",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context), // balik ke kamera
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Coba Scan Ulang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF45B1F9),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER IKAN
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  ikan!['gambar_url'],
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ikan!['nama'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ikan!['nama_ilmiah'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${ikan!['deskripsi'].toString().split(' ').take(10).join(' ')}...',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF45B1F9),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/detail_ikan',
                                          arguments: ikan,
                                        );
                                      },
                                      child: const Text(
                                        "Pelajari lebih lanjut",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // STATUS
                        const Text(
                          "Status",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.status.toLowerCase() == 'sehat'
                                ? const Color(0xFFD6F5D6)
                                : const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.status.toLowerCase() == 'sehat'
                                    ? Icons.check_circle_outline
                                    : Icons.warning_amber_outlined,
                                color: widget.status.toLowerCase() == 'sehat'
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.status.toLowerCase() == 'sehat'
                                      ? "Ikan kamu sehat-sehat saja 🐟✨"
                                      : "Ikan kamu terkena ${widget.status} ⚠️",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PENYAKIT (JIKA ADA)
                        if (widget.status.toLowerCase() != 'sehat' && penyakitList.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            "Penyakit yang Mungkin Terjadi",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...penyakitList.map(
                            (p) => Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.nama,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Deskripsi: ${p.deskripsi}"),
                                  Text("Gejala: ${p.gejala}"),
                                  Text("Solusi: ${p.solusi}"),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // CATATAN
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF45B1F9), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Catatan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF45B1F9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Scanner Nemo.AI memiliki akurasi sekitar 80%. "
                                "Jika kamu masih ragu atau ingin konsultasi lebih lanjut, "
                                "kamu bisa bertanya langsung ke Fishbot.",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF45B1F9),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/fishbot');
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  label: const Text("Tanya ke Fishbot"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}