import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/ensiklopedia/list_ikan_screen.dart';
import 'package:nemo_mobile/screens/home/artikel_screen.dart';
import 'package:nemo_mobile/data/dummy_artikel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✅ Fungsi salam waktu
  String greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Selamat Pagi! ';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang! ';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore! ';
    } else {
      return 'Selamat Malam! ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hai,',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: greetingMessage(),
                            style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                              text: '👋',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // avatar
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/akun'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('lib/assets/images/logo_bulat.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16), // spasi ke search bar

              // search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Temukan ikan hias...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),

            const SizedBox(height: 32),

            // 📚 Artikel
            const Text(
              'Yuk mulai dengan membaca ini!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artikelList.length,
                itemBuilder: (context, index) {
                  final artikel = artikelList[index];
                  return _buildArticleCard(
                    imageUrl: artikel.imageUrl,
                    title: artikel.title,
                    category: 'Pengetahuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtikelScreen(
                            title: artikel.title,
                            content: artikel.content,
                            imageUrl: artikel.imageUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // 🐠 Kategori
            const Text(
              'Kategori',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 0),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Ikan Air Tawar'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Ikan Air Tawar',
                    'lib/assets/images/ikan_air_tawar.jpg',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Ikan Laut'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Ikan Laut',
                    'lib/assets/images/ikan_laut.jpg',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Ikan Air Payau'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Ikan Air Payau',
                    'lib/assets/images/ikan_air_payau.jpg',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Ikan Air Dingin'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Ikan Air Dingin',
                    'lib/assets/images/ikan_air_dingin.jpg',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Ikan Predator'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Ikan Predator',
                    'lib/assets/images/ikan_predator.jpg',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListIkanScreen(kategori: 'Invertebrata'),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    'Invertebrata',
                    'lib/assets/images/invertebrata.jpg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard({
    required String imageUrl,
    required String title,
    required String category,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
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

  Widget _buildCategoryCard(String title, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Gambar background
          Positioned.fill(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Gradasi hitam di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
            ),
          ),

          // Teks kategori
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black54,
                    offset: Offset(1, 1),
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
