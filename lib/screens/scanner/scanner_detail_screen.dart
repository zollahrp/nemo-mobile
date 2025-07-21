// lib/screens/scanner_detail_screen.dart

import 'package:flutter/material.dart';

class ScannerDetailScreen extends StatelessWidget {
  final String result;

  const ScannerDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Scan")),
      body: Center(
        child: Text(
          "Hasil: $result",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
