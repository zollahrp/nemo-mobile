import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nemo_mobile/main.dart';
import 'package:nemo_mobile/screens/auth/masuk_screen.dart';
import 'package:nemo_mobile/screens/settings/faq_screen.dart';
import 'package:nemo_mobile/screens/settings/terms_screen.dart';
import 'package:nemo_mobile/screens/settings/privacy_policy_screen.dart';
import 'package:nemo_mobile/screens/settings/informasi_personal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'] ?? 'Pengguna';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFFFAFAFA),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Avatar dan nama dari Supabase
          if (profileImageUrl != null)
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(profileImageUrl),
            )
          else
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blue,
              child: Text(
                fullName.isNotEmpty ? fullName[0] : '?',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),

          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),

          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // menuTile(Icons.person, 'Informasi Personal', () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const InformasiPersonalScreen()),
                //   );
                // }),
                menuTile(Icons.help_outline, 'FAQ', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                }),
                menuTile(Icons.folder_open, 'Terms of Service', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsScreen()),
                  );
                }),
                menuTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                }),

                const SizedBox(height: 8),

                // Logout
                menuTile(Icons.logout, 'Log Out', () async {
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut();
                  await supabase.auth.signOut();

                  // TAMBAHKAN INI 👇
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }, textColor: Colors.red),

                // Hapus akun (masih kosong logicnya)
                menuTile(Icons.delete, 'Hapus Akun', () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus Akun'),
      content: const Text('Apakah kamu yakin ingin menghapus akun ini? Tindakan ini tidak bisa dibatalkan.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  final user = supabase.auth.currentUser;
  if (user == null) return;

  // 1. Hapus dari tabel `profiles`
  await supabase.from('profiles').delete().eq('id', user.id);

  // 2. Logout (optional: Google sign out)
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  await supabase.auth.signOut();

  // 3. Clear shared preferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');

  // 4. Arahkan ke login screen
  if (context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}, textColor: Colors.red),
              ],
            ),
          ),

          // Versi
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Version 1.3.0.32010',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuTile(IconData icon, String title, VoidCallback onTap,
      {Color textColor = Colors.black}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: textColor == Colors.red ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
