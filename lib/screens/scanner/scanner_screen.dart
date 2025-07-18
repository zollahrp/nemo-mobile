import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // biar kayak preview kamera
      body: SafeArea(
        child: Stack(
          children: [
            // Placeholder area kamera (warna hitam)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'lib/assets/images/scan_frame.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Scan dengan jarak 50–70 cm',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
