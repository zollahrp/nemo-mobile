import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/IkanModel.dart';

class DetailIkanScreen extends StatelessWidget {
  final IkanModel ikan;
  const DetailIkanScreen({super.key, required this.ikan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.network(
                    ikan.gambarUrl,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 40, // bisa diatur sesuai kebutuhan notch
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            // Card nama + ilmiah (Glassmorphism)
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08), // warna bayangan
                        blurRadius: 16, // seberapa blur
                        offset: const Offset(0, 8), // arah bayangan (x, y)
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Kiri: Nama & Ilmiah
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ikan.nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${ikan.namaIlmiah} · ${ikan.umur}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kanan: Icon dalam kartu biru khas Nemo
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF38ABF8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.pets, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ),
                ),
                ),
              ),
            ),

            const SizedBox(height: -0),

            // Tentang [nama]
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text(
                        "Tentang ${ikan.nama}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoCard("Suhu", ikan.suhu),
                      _infoCard("Ukuran", ikan.ukuran),
                      _infoCard("pH", ikan.ph),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    ikan.deskripsi,
                    style: const TextStyle(fontSize: 14.5, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Informasi Lain
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dashboard_customize_rounded, color: Colors.black87),
                      const SizedBox(width: 8),
                      const Text(
                        "Informasi Lain",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailItem("Jenis", ikan.jenis, Icons.bubble_chart),
                        _buildDetailItem("Asal", ikan.asal, Icons.map),
                        _buildDetailItem("Oksigen", ikan.oksigen, Icons.air_rounded),
                        _buildDetailItem("Kategori", ikan.kategori, Icons.star_rate_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reversed label & value position
  Widget _infoCard(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECF7FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF38ABF8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF38ABF8)),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
