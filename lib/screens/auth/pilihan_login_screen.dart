import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nemo_mobile/main.dart';
import 'package:nemo_mobile/screens/home/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PilihanLoginScreen extends StatelessWidget {
  const PilihanLoginScreen({super.key});

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      const webClientId = '875919720477-uubbvahve38uf4k81od5avf8im21d9n5.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) throw 'Login dibatalkan';

      final googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Token tidak ditemukan';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Center(
                child: Image.asset(
                  'lib/assets/images/logo_bulat.png',
                  height: 160,
                ),
              ),
              const SizedBox(height: 50),
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
              const SizedBox(height: 64),

              /// Tombol Google Login langsung
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _googleSignIn(context),
                  icon: Image.asset('lib/assets/images/Google_G_logo.svg.png', height: 20),
                  label: const Text('Masuk dengan Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF0E91E9)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
