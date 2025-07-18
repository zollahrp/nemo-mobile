import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/settings/faq_screen.dart';
import 'package:nemo_mobile/screens/settings/terms_screen.dart';
import 'package:nemo_mobile/screens/settings/privacy_policy_screen.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Avatar dan nama
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.blue,
            child: Text(
              'F',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jawara Team',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),

          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                menuTile(Icons.person, 'Informasi Personal', () {}),
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
                menuTile(Icons.logout, 'Log Out', () {}, textColor: Colors.red),
                menuTile(Icons.delete, 'Hapus Akun', () {}, textColor: Colors.red),
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
