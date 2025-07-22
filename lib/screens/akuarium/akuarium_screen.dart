import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/akuarium/Set_Ecosystem_Screen.dart';

class AkuariumScreen extends StatelessWidget {
  const AkuariumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akuarium Saya')),
      body: const Center(
        child: Text('Belum ada akuarium tersimpan.'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SetEcosystemScreen()),
          );
        },
        label: const Text('Tambah Akuarium'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
