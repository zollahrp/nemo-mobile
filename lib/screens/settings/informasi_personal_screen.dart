import 'package:flutter/material.dart';
import 'package:nemo_mobile/widgets/custom_button.dart';

class InformasiPersonalScreen extends StatefulWidget {
  const InformasiPersonalScreen({super.key});

  @override
  State<InformasiPersonalScreen> createState() => _InformasiPersonalScreenState();
}

class _InformasiPersonalScreenState extends State<InformasiPersonalScreen> {
  final TextEditingController _namaController = TextEditingController(text: 'Cuko Pempek Enjoyer');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Informasi Personal'),
        backgroundColor: const Color(0xFFFAFAFA),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue.shade100,
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/default_profile.png'), // ganti sesuai path asset kamu
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF003D5B),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            _inputCard(
              title: 'Nama',
              controller: _namaController,
            ),
            const SizedBox(height: 12),
            _inputCard(
              title: 'Ubah Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _inputCard(
              title: 'Konfirmasi Password',
              controller: _konfirmasiPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Simpan',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data berhasil disimpan')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Batal',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Version 1.3.0.32010',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputCard({
    required String title,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
