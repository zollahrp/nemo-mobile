import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/IkanModel.dart';
import 'package:nemo_mobile/screens/ensiklopedia/detail_ikan_screen.dart';
import 'package:shimmer/shimmer.dart';

class ListIkanScreen extends StatefulWidget {
  const ListIkanScreen({super.key});

  @override
  State<ListIkanScreen> createState() => _ListIkanScreenState();
}

class _ListIkanScreenState extends State<ListIkanScreen> {
  final supabase = Supabase.instance.client;
  List<IkanModel> listIkan = [];
  bool isLoading = true;
  String searchQuery = '';
  String kategoriTerpilih = 'All';

  final List<Map<String, String>> kategoriList = [
    {'label': 'All', 'image': 'ikan.png'},
    {'label': 'Air Tawar', 'image': 'ikan_air_tawar.jpg'},
    {'label': 'Laut', 'image': 'ikan_laut.jpg'},
    {'label': 'Air Payau', 'image': 'ikan_air_payau.jpg'},
    {'label': 'Air Dingin', 'image': 'ikan_air_dingin.jpg'},
    {'label': 'Predator', 'image': 'ikan_predator.jpg'},
    {'label': 'Invertebrata', 'image': 'invertabrata.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    fetchIkan();
  }

  Future<void> fetchIkan() async {
    setState(() => isLoading = true);
    final response = await supabase.from('ikan').select();
    final data = response as List<dynamic>;
    listIkan = data.map((e) => IkanModel.fromMap(e)).toList();
    setState(() => isLoading = false);
  }

  String formatKategoriLabel(String label) {
    if (label == 'All') return 'All';
    return 'Ikan $label';
  }

  @override
    Widget build(BuildContext context) {
    final filteredIkan = listIkan.where((ikan) {
      final cocokKategori = kategoriTerpilih == 'All' || ikan.kategori == 'Ikan $kategoriTerpilih';
      final cocokSearch = ikan.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return cocokKategori && cocokSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // 🔹 HEADER STICKY (judul + search)
          Container(
            width: double.infinity,
            color: const Color(0xFFE0F2FE),
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              children: [
                // 🔽 BACKGROUND DEKORASI
                Positioned(
                  bottom: -10, // sedikit keluar biar nggak kekunci padding
                  left: -10,
                  child: Image.asset(
                    'lib/assets/images/top1.png',
                    height: 90,
                  ),
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Image.asset(
                    'lib/assets/images/top2.png',
                    height: 90,
                  ),
                ),

                // 🔼 FOREGROUND: Title + Search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          BackButton(),
                          SizedBox(width: 8),
                          Text(
                            "Ensiklopedia ikan hias",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2), // warna stroke hitam agak transparan
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => searchQuery = val),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            hintText: 'Cari ikan hias...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔽 BISA DISCROLL: kategori + grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔸 KATEGORI SECTION
                  Container(
                  color: const Color(0xFFFAFAFA),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: kategoriList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final kategori = kategoriList[index];
                          final selected = kategoriTerpilih == kategori['label'];
                          return GestureDetector(
                            onTap: () => setState(() => kategoriTerpilih = kategori['label']!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected ? Colors.blue[100] : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selected ? Colors.blue : Colors.grey.shade300,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage('lib/assets/images/${kategori['image']}'),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formatKategoriLabel(kategori['label']!),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 0),

                  // 🐟 GRID IKAN
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4.0,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: 4,
                            itemBuilder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8, // samain kayak card
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.90,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filteredIkan.length,
                            itemBuilder: (context, index) {
                              final ikan = filteredIkan[index];
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => DetailIkanScreen(ikan: ikan),
                                    transitionsBuilder: (_, animation, __, child) => FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.network(
                                            ikan.gambarUrl,
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          // Positioned(
                                          //   top: 8,
                                          //   right: 8,
                                          //   child: Container(
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       shape: BoxShape.circle,
                                          //       boxShadow: [
                                          //         BoxShadow(
                                          //           color: Colors.black26,
                                          //           blurRadius: 4,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     child: const Icon(
                                          //       Icons.star_border,
                                          //       size: 20,
                                          //       color: Colors.grey,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ikan.nama,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ikan.namaIlmiah,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
}
