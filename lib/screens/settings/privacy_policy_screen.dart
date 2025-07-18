import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            title: 'Data yang Dikumpulkan',
            content:
                'Nemo.Ai hanya mengumpulkan data yang diperlukan seperti nama, email, dan informasi akuarium untuk meningkatkan pengalaman pengguna.',
          ),
          _sectionCard(
            title: 'Penggunaan Data',
            content:
                'Data digunakan untuk fitur personalisasi, pemantauan kesehatan ikan, serta penyempurnaan layanan aplikasi.',
          ),
          _sectionCard(
            title: 'Keamanan Informasi',
            content:
                'Kami menggunakan teknologi enkripsi dan protokol keamanan terkini untuk melindungi data pengguna dari akses yang tidak sah.',
          ),
          _sectionCard(
            title: 'Pihak Ketiga',
            content:
                'Nemo.Ai tidak membagikan data pengguna kepada pihak ketiga tanpa persetujuan kecuali diwajibkan oleh hukum.',
          ),
          _sectionCard(
            title: 'Kontak Kami',
            content:
                'Jika ada pertanyaan mengenai privasi, kamu bisa menghubungi kami melalui email: support@nemoai.id.',
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required String content}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
