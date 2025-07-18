import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FaqItem(
            question: 'Apa itu aplikasi Nemo.Ai?',
            answer:
                'Nemo.Ai adalah aplikasi pintar untuk pecinta ikan hias, yang membantu merawat, mengelola, dan memantau akuarium kamu.',
          ),
          FaqItem(
            question: 'Bagaimana cara menambahkan ikan baru?',
            answer:
                'Kamu bisa menambahkan ikan baru melalui fitur “Tambahkan Ikan” di halaman utama aplikasi.',
          ),
          FaqItem(
            question: 'Apakah aplikasi ini bisa mendeteksi penyakit ikan?',
            answer:
                'Ya, aplikasi memiliki fitur pendeteksi penyakit berbasis AI untuk membantu menjaga kesehatan ikan.',
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(answer),
            ),
          ],
        ),
      ),
    );
  }
}
