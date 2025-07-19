import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens
import 'screens/home/main_screen.dart';
import 'screens/auth/pilihan_login_screen.dart';
import 'screens/auth/masuk_screen.dart';
import 'screens/auth/daftar_screen.dart';
import 'screens/fishbot/fishbot_screen.dart';
import 'screens/settings/akun_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
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

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nemo Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const FiturScreen(),
      routes: {
        '/login': (context) => const PilihanLoginScreen(),
        '/masuk': (context) => const LoginScreen(),
        '/daftar': (context) => const DaftarScreen(),
        '/fishbot': (context) => const FishBotScreen(),
        '/akun': (context) => const AkunScreen(),
      },
    );
  }
}
