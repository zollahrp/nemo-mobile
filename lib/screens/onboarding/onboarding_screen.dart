import 'package:flutter/material.dart';
import 'package:nemo_mobile/widgets/custom_button.dart';

class FiturScreen extends StatefulWidget {
  const FiturScreen({super.key});

  @override
  State<FiturScreen> createState() => _FiturScreenState();
}

class _FiturScreenState extends State<FiturScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> fiturList = [
    {
      'image': 'lib/assets/images/fitur1.png',
      'title': 'Scanner Ikan Hias',
      'desc': 'Kamu dapat scan ikan hias menggunakan kamera ponselmu dan mendapatkan informasi lengkap tentangnya termasuk apakah ada penyakit atau tidak.'
    },
    {
      'image': 'lib/assets/images/fitur2.png',
      'title': 'Fishbot',
      'desc': 'Konsultasikan masalah ikan hiasmu dengan Fishbot dan dapatkan solusi cepat.'
    },
    {
      'image': 'lib/assets/images/fitur3.png',
      'title': 'Pengingat Perawatan',
      'desc': 'Dapatkan pengingat untuk merawat ikan hias dan menjaga kebersihan akuarium kamu.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset('lib/assets/images/logo_kecil.png', height: 40),
              ),
            ),

            // CAROUSEL
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: fiturList.length,
                itemBuilder: (context, index) {
                  final fitur = fiturList[index];
                  return Column(
                    children: [
                      const SizedBox(height: 64), 
                      Image.asset(fitur['image']!, height: 220),
                      const SizedBox(height: 42), 

                      // Container background rectangle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                fitur['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                fitur['desc']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                fiturList.length,
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BUTTON
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                child: _currentIndex == fiturList.length - 1
                    ? CustomButton(
                        text: "Yuk Mulai",
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      )
                    : CustomButton(
                        text: "Lanjut",
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
              ),
            ),


            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
