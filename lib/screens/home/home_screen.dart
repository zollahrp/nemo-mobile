import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/ensiklopedia/list_ikan_screen.dart';
import 'package:nemo_mobile/screens/home/artikel_screen.dart';
import 'package:nemo_mobile/data/dummy_artikel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui'; 

final user = Supabase.instance.client.auth.currentUser;
final fullName = user?.userMetadata?['full_name'] ?? 'Pengguna';
final avatarUrl = user?.userMetadata?['avatar_url'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getFirstName(String fullName) {
    List<String> parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : '';
  }

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHorizontalBanner(),
                    
                  const SizedBox(height: 24),
                  buildTopFiturSection(),
                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Yuk mulai dengan membaca ini!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),

                    const SizedBox(height: 12),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SizedBox(
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
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kategori',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                    constraints: const BoxConstraints(maxHeight: 600), // batas tinggi biar gak ngambil banyak ruang
                    child: GridView.count(
                      padding: EdgeInsets.zero, // buang padding internal
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 2, // biar lebih lebar, gak terlalu tinggi
                      children: [
                        _buildCategoryTile('Ikan Air Tawar', 'lib/assets/images/ikan_air_tawar.jpg'),
                        _buildCategoryTile('Ikan Laut', 'lib/assets/images/ikan_laut.jpg'),
                        _buildCategoryTile('Ikan Air Payau', 'lib/assets/images/ikan_air_payau.jpg'),
                        _buildCategoryTile('Ikan Air Dingin', 'lib/assets/images/ikan_air_dingin.jpg'),
                        _buildCategoryTile('Ikan Predator', 'lib/assets/images/ikan_predator.jpg'),
                        _buildCategoryTile('Invertebrata', 'lib/assets/images/invertebrata.jpg'),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Dipindah ke luar build()
  Widget _buildHorizontalBanner() {
    final List<Map<String, dynamic>> bannerData = [
      {
        'title': 'Cek dulu yuk, ikan kamu lagi baik-baik aja gak ya?',
        'buttonText': 'Mulai Diagnosa',
        'bgColor': const Color(0xFFD4EDFF),
        'image': 'lib/assets/images/fitur1.png',      },
      {
        'title': 'Yuk, rawat ikan kesayangan kamu bersama Nemo!',
        'buttonText': 'Lihat Checklist Harian',
        'bgColor': const Color(0xFFE0F7E9),
        'image': 'lib/assets/images/fitur1.png',      },
      {
        'title': 'Biar makin jago, yuk belajar soal ikan!',
        'buttonText': 'Lihat Sekarang',
        'bgColor': const Color(0xFFF5E9FF),
        'image': 'lib/assets/images/fitur1.png',      },
      {
        'title': 'Kalau kamu jadi ikan, kamu jadi yang mana ya?',
        'buttonText': 'Mau tau',
        'bgColor': const Color(0xFFFFF5E0),
        'image': 'lib/assets/images/fitur1.png',      },
    ];

    return SizedBox(
      height: 130, // tinggi banner
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: bannerData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isLast = index == bannerData.length - 1;

          final data = bannerData[index];
         return Container(
          width: 300,
          height: 100,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: data['bgColor'],
            borderRadius: BorderRadius.circular(16),
          ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // aksi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(10, 32), // biar gak auto-besar
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // hapus area klik default gede
                          textStyle: const TextStyle(fontSize: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Coba Sekarang"), // atau pakai data['buttonText']
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  data['image'],
                  width: 60,
                  height: 60,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// ini buat bagian atas
 Widget _buildHeader() {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 24), // Lebih jauh dari atas
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // semi transparan untuk blur
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/akun'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  image: avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('lib/assets/images/logo_bulat.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Greeting & Nama
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, ${_getFirstName(fullName)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    greetingMessage(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Search mini
            Expanded(
              flex: 2,
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, size: 20, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      'Cari ikan',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Notifikasi
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                  onPressed: () {
                    // aksi ketika ditekan
                  },
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Text(
                      '116',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildTopFiturSection() {
  final fiturList = [
    {'label': 'Graphic Design', 'icon': Icons.draw, 'color': Color(0xFFC1F4D3), 'iconColor': Color(0xFF00C853)},
    {'label': '3D Design', 'icon': Icons.view_in_ar, 'color': Color(0xFFC7E5FF), 'iconColor': Color(0xFF2979FF)},
    {'label': 'Art Design', 'icon': Icons.color_lens, 'color': Color(0xFFFFF1D2), 'iconColor': Color(0xFFFF6D00)},
    {'label': 'Healthy Cate', 'icon': Icons.self_improvement, 'color': Color(0xFFE3DAFF), 'iconColor': Color(0xFF6200EA)},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Top Fitur",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: fiturList.length,
          itemBuilder: (context, index) {
            final fitur = fiturList[index];
            return Container(
              margin: const EdgeInsets.only(right: 12),
              width: 90,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // Card background
                  Positioned(
                    top: 20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: fitur['color'] as Color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.only(top: 28, left: 6, right: 6),
                      child: Center(
                        child: Text(
                          fitur['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  // Icon bulat di atas
                  Positioned(
                    top: 0,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        fitur['icon'] as IconData,
                        color: fitur['iconColor'] as Color,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
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

  Widget _buildCategoryTile(String title, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListIkanScreen(kategori: title),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
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
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}