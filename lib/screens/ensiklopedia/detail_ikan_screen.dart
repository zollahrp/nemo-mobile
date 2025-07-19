import 'package:flutter/material.dart';
import '../../models/ikanmodel.dart';

class DetailIkanScreen extends StatelessWidget {
  final IkanModel ikan;

  const DetailIkanScreen({super.key, required this.ikan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ikan.nama)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ikan.gambarUrl, width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ikan.nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(ikan.namaIlmiah, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  const Text("Ikan Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(ikan.deskripsi, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  _buildInfoRow("Suhu", ikan.suhu),
                  _buildInfoRow("Jenis", ikan.jenis),
                  _buildInfoRow("yg lain", ikan.ygLain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
