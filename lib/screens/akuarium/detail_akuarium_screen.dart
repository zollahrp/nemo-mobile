import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/akuarium_model.dart';

class DetailAkuariumScreen extends StatelessWidget {
  final AkuariumModel akuarium;

  const DetailAkuariumScreen({super.key, required this.akuarium});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFE),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Akuarium: ${akuarium.nama}", style: _infoStyle()),
                    const SizedBox(height: 12),
                    Text("Ukuran: ${akuarium.tankSizeL} Liter", style: _infoStyle()),
                    const SizedBox(height: 12),
                    Text("Suhu: ${akuarium.temperature}°C", style: _infoStyle()),
                    const SizedBox(height: 12),
                    Text("pH: ${akuarium.ph}", style: _infoStyle()),
                    const SizedBox(height: 12),
                    Text("ID Ikan: ${akuarium.ikanId}", style: _infoStyle()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _infoStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      child: Stack(
        children: [
          Positioned(
            bottom: -10,
            left: -10,
            child: Image.asset('lib/assets/images/top1.png', height: 90),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Image.asset('lib/assets/images/top2.png', height: 90),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              Text(
                akuarium.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Detail lengkap dari akuarium kamu",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
