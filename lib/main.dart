import 'package:flutter/material.dart';
import 'screens/home/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/masuk_screen.dart';
import 'screens/auth/daftar_screen.dart';
import 'screens/fishbot/fishbot_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/settings/akun_screen.dart';
// import 'screens/onboarding/onboarding_screen.dart';

Future<void> main() async {
  await dotenv.load(); // Ini yang load file .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nemo Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // ganti ke MainScreen langsungFiturScreen
      // home: const FiturScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/masuk': (context) => const MasukScreen(),
        '/daftar': (context) => const DaftarScreen(),
        '/fishbot': (context) => const FishBotScreen(),
        '/akun': (context) => const AkunScreen(),
      },
    );
  }
}
