// import 'package:flutter/material.dart';
// import 'package:nemo_mobile/main.dart';
// import 'package:nemo_mobile/screens/auth/masuk_screen.dart';
// import 'package:nemo_mobile/screens/home/onboarding_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<AuthState>(
//       stream: supabase.auth.onAuthStateChange,
//       builder: (context, snapshot) {
//         final session = supabase.auth.currentSession;

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (session == null) {
//           return const MasukScreen();
//         } else {
//           return const FiturScreen();
//         }
//       },
//     );
//   }
// }
