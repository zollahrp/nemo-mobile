import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syarat & Ketentuan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Syarat dan Ketentuan Penggunaan Nemo.Ai',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            Text(
              '1. Pengantar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Dengan menggunakan aplikasi Nemo.Ai, Anda menyetujui semua syarat dan ketentuan yang berlaku. Jika Anda tidak setuju dengan ketentuan ini, harap tidak menggunakan aplikasi ini.',
            ),
            SizedBox(height: 12),

            Text(
              '2. Penggunaan Aplikasi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Aplikasi ini ditujukan untuk membantu pengguna dalam merawat ikan hias dan mengelola ekosistem akuarium mereka. Dilarang menggunakan aplikasi ini untuk tujuan ilegal atau merugikan pihak lain.',
            ),
            SizedBox(height: 12),

            Text(
              '3. Data dan Privasi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Nemo.Ai menjaga kerahasiaan informasi pribadi Anda. Kami tidak akan membagikan data pribadi Anda kepada pihak ketiga tanpa persetujuan Anda.',
            ),
            SizedBox(height: 12),

            Text(
              '4. Perubahan Layanan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Nemo.Ai berhak untuk melakukan perubahan pada fitur atau menghentikan layanan kapan saja tanpa pemberitahuan sebelumnya.',
            ),
            SizedBox(height: 12),

            Text(
              '5. Kontak dan Dukungan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Jika Anda memiliki pertanyaan atau masukan, silakan hubungi kami melalui halaman Dukungan di dalam aplikasi.',
            ),
            SizedBox(height: 24),
            Text(
              'Terima kasih telah menggunakan Nemo.Ai!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
