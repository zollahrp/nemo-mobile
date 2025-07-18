import 'package:flutter/material.dart';
import 'screens/fitur/fitur_screen.dart';
import 'screens/auth/login_screen.dart';

void main() {
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
      home: const FiturScreen(),

      // Tambahin ini buat daftar rute navigasi
      routes: {
        '/login': (context) => const LoginScreen(),
        // tambahin rute lain kalau ada, misalnya:
        // '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
