// lib/screens/ensiklopedia/detail_ikan_screen.dart
import 'package:flutter/material.dart';

class DetailIkanScreen extends StatelessWidget {
  final String namaIkan;

  const DetailIkanScreen({super.key, required this.namaIkan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(namaIkan)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$namaIkan adalah salah satu jenis ikan yang memiliki ciri khas bla bla bla...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
