import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

// Screens
import 'screens/home/main_screen.dart';
import 'screens/auth/pilihan_login_screen.dart';
import 'screens/auth/masuk_screen.dart';
import 'screens/auth/daftar_screen.dart';
import 'screens/fishbot/fishbot_screen.dart';
import 'screens/ensiklopedia/detail_ikan_screen.dart';
import 'models/IkanModel.dart';
import 'screens/settings/akun_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

  final supabase = Supabase.instance.client;

    Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load .env
    await dotenv.load(fileName: ".env");

    // Init Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    // Inisialisasi locale Indonesia
    await initializeDateFormatting('id_ID', null);

    // ✅ Tes print format tanggal
    final tanggalFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    print('Tanggal lokal: $tanggalFormatted');

    // Cek onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
  }

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
    Widget build(BuildContext context) {
      return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nemo.Ai',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
    ),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('id', 'ID'),
    ],
    home: SplashScreen(hasSeenOnboarding: hasSeenOnboarding),
    routes: {
      '/login': (context) => const PilihanLoginScreen(),
      '/masuk': (context) => const LoginScreen(),
      '/daftar': (context) => const DaftarScreen(),
      '/fishbot': (context) => const FishBotScreen(),
      '/akun': (context) => const AkunScreen(),
      '/main': (context) => const MainScreen(),
      '/detail_ikan': (context) {
        final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final ikanModel = IkanModel.fromMap(data);
        return DetailIkanScreen(ikan: ikanModel);
      },
    },
  );
  }
}
