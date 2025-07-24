import 'package:flutter/material.dart';
import 'dart:async';
import 'scanner_detail_screen.dart';

class ScanningScreen extends StatefulWidget {
  final Future<Map<String, String>> processFuture;

  const ScanningScreen({super.key, required this.processFuture});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _messages = [
    "Gambar kamu sedang dianalisis...",
    "Mengecek jenis ikan dengan kecerdasan buatan...",
    "Mendeteksi kemungkinan penyakit...",
    "Mengumpulkan hasil akhir...",
  ];

  int _visibleCount = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_visibleCount < _messages.length) {
        setState(() => _visibleCount++);
      } else {
        _messageTimer?.cancel();
        widget.processFuture.then((result) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerDetailScreen(
                jenisIkan: result['jenis']!,
                status: result['status']!,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            children: [
              // Gambar di atas
              Image.asset(
                'lib/assets/images/scan.png',
                height: 300, // diperbesar dari 120 ke 160
              ),
              const SizedBox(height: 32),

              // Pesan proses AI
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_visibleCount, (index) {
                    final isActive = index == _visibleCount - 1 && _visibleCount < _messages.length;

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: isActive
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.blueAccent,
                                      ),
                                    )
                                  : const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                _messages[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.black : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
