// import 'package:supabase_flutter/supabase_flutter.dart';

// Future<void> signInWithGoogle() async {
//   final supabase = Supabase.instance.client;

//   final res = await supabase.auth.signInWithOAuth(OAuthProvider.google);

//   // Tunggu login selesai
//   final user = supabase.auth.currentUser;

//   if (user == null) {
//     print('Login gagal');
//     return;
//   }

//   // Cek apakah user sudah ada di profiles
//   final existing = await supabase
//       .from('profiles')
//       .select()
//       .eq('id', user.id)
//       .maybeSingle();

//   if (existing == null) {
//     // Belum ada, insert ke table profiles
//     await supabase.from('profiles').insert({
//       'id': user.id,
//       'email': user.email,
//       'created_at': DateTime.now().toIso8601String(),
//       // kamu bisa tambahkan nama/avatar kalau dapet dari metadata
//     });
//   }
// }

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signInWithGoogle() async {
  await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: 'com.example.nemo_mobile://login-callback',
  );
}
