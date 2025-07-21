import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIkan();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          ikan!['gambar_url'],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ikan!['nama'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ikan!['nama_ilmiah'],
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
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
                    ],
                  ),
                ),
    );
  }
}
