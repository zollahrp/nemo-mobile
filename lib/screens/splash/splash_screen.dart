// // splash_screen.dart
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../home/main_screen.dart';
// import '../onboarding/onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLogin();
//   }

//   Future<void> _checkLogin() async {
//     await Future.delayed(const Duration(seconds: 2)); // Splash delay

//     final session = Supabase.instance.client.auth.currentSession;

//     if (session != null) {
//       // Sudah login
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const MainScreen()),
//       );
//     } else {
//       // Belum login → ke onboarding
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const FiturScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text('Splash...')),
//     );
//   }
// }
