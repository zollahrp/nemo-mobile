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
      appBar: AppBar(title: const Text("Hasil Scan")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ikan == null
              ? Center(child: Text("Ikan '${widget.jenisIkan}' tidak ditemukan."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                ikan!['gambar_url'],
                                width: 120,
                                height: 120,
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
                                        fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ikan!['nama_ilmiah'],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Pelajari lebih lengkap ikan ini dengan klik tombol di bawah ini.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail_ikan',
                                        arguments: ikan,
                                      );
                                    },
                                    child: const Text("Pelajari lebih lanjut"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 12),
                        const Text(
                          "Status",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.status.toLowerCase() == 'sehat'
                              ? "Ikan kamu sehat-sehat saja 🐟✨"
                              : "Ikan kamu terkena ${widget.status} ⚠️",
                          style: const TextStyle(fontSize: 16),
                        ),

                        // Penyakit List
                        if (widget.status.toLowerCase() != 'sehat' && penyakitList.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            "Penyakit yang mungkin terjadi",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...penyakitList.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nama,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text("Deskripsi: ${p.deskripsi}"),
                                const SizedBox(height: 4),
                                Text("Gejala: ${p.gejala}"),
                                const SizedBox(height: 4),
                                Text("Solusi: ${p.solusi}"),
                              ],
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
