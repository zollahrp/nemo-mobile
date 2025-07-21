import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/IkanModel.dart';

class DetailIkanScreen extends StatelessWidget {
  final IkanModel ikan;

  const DetailIkanScreen({super.key, required this.ikan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ikan.nama),
        backgroundColor: const Color(0xFF45B1F9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                ikan.gambarUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ikan.nama,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ikan.namaIlmiah,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Ikan Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ikan.deskripsi,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Informasi Teknis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF45B1F9), width: 1),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Informasi Penting",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF45B1F9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),

                    _buildInfoRow("Suhu", ikan.suhu),
                    _buildInfoRow("Jenis", ikan.jenis),
                    _buildInfoRow("pH", ikan.ph),
                    _buildInfoRow("Oksigen", ikan.oksigen),
                    _buildInfoRow("Ukuran", ikan.ukuran),
                    _buildInfoRow("Umur", ikan.umur),
                    _buildInfoRow("Asal", ikan.asal),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}
