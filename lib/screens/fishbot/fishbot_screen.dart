import 'package:flutter/material.dart';

class FishBotScreen extends StatelessWidget {
  const FishBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Ikan
                Image.asset(
                  'lib/assets/images/logo.png',
                  width: 120,
                ),
                const SizedBox(height: 24),

                // Judul
                const Text(
                  'Membutuhkan bantuan?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Deskripsi
                const Text(
                  'AI kami siap membantu Kamu dengan\nmasalah ikan hias apa pun yang mungkin\nKamu hadapi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Input Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ketik disini...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
