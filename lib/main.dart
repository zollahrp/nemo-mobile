import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/masuk_screen.dart';
import 'screens/auth/daftar_screen.dart';
import 'screens/fishbot/fishbot_screen.dart';
import 'screens/settings/akun_screen.dart';
// import 'screens/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // Load file .env


await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  authOptions: const FlutterAuthClientOptions(), 
  realtimeClientOptions: const RealtimeClientOptions(
    logLevel: RealtimeLogLevel.info,
  ),
  storageOptions: const StorageClientOptions(
    retryAttempts: 10,
  ),
);


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
      home: const MainScreen(),
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
