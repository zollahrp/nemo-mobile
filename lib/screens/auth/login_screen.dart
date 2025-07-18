import 'package:flutter/material.dart';
import 'package:nemo_mobile/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64), // jarak logo agak ke bawah

              // Logo
              Center(
                child: Image.asset(
                  'lib/assets/images/logo_bulat.png',
                  height: 160,
                ),
              ),

              const SizedBox(height: 50),

              // Title
              const Text.rich(
                TextSpan(
                  text: 'Solusi Cerdas Bagi para\npecinta ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Ikan Hias',
                      style: TextStyle(color: Color(0xFF0E91E9)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 58), // Tambah jarak sebelum tombol

              // Sign In Button
              CustomButton(
                text: "Masuk",
                onPressed: () {
                  // TODO: Arahkan ke form login
                },
              ),

              const SizedBox(height: 34),

              // OR line
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Atau Daftar"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 34),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF0E91E9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // TODO: Arahkan ke form signup
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(color: Color(0xFF0E91E9)),
                  ),
                ),
              ),

              const Spacer(),

              const Text(
                "© 2025 . All rights reserved.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
