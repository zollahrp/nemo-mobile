import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/ensiklopedia/list_ikan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Greeting dan avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai, user!',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Selamat Pagi!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('F'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Temukan ikan hias',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildArticleCard(
                    imageUrl: 'lib/assets/images/artikel1.jpg',
                    title: 'Bagaimana cara identifikasi ikan',
                    category: 'Knowledge',
                  ),
                  _buildArticleCard(
                    imageUrl: 'lib/assets/images/artikel1.jpg',
                    title: 'Bagaimana memilih ikan sehat',
                    category: 'Life Style',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 🐠 Kategori
            const Text(
              'Kategori',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

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
  }) {
    return Container(
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
          // Gradasi gelap bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80, // Tambahin tinggi supaya gradasi naik
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87], // Lebih gelap biar jelas
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
