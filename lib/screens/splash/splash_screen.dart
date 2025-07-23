import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:nemo_mobile/screens/home/main_screen.dart';
import 'package:nemo_mobile/screens/auth/pilihan_login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  final bool hasSeenOnboarding;

  const SplashScreen({super.key, required this.hasSeenOnboarding}); // ✅ tambahkan parameter ini

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkRoute();
  }

  Future<void> _checkRoute() async {
    await Future.delayed(const Duration(seconds: 2)); // efek loading

    final user = Supabase.instance.client.auth.currentUser;

    if (!widget.hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FiturScreen()),
      );
    } else if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilihanLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
