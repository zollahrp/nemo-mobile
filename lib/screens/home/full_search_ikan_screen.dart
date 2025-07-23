import 'package:flutter/material.dart';
import 'package:nemo_mobile/models/IkanModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/screens/ensiklopedia/detail_ikan_screen.dart';

class FullSearchIkanScreen extends StatefulWidget {
  const FullSearchIkanScreen({super.key});

  @override
  State<FullSearchIkanScreen> createState() => _FullSearchIkanScreenState();
}

class _FullSearchIkanScreenState extends State<FullSearchIkanScreen> {
  final TextEditingController _searchController = TextEditingController();
  final supabase = Supabase.instance.client;

  List<IkanModel> _allFish = [];
  List<IkanModel> _filteredFish = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFish();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchFish() async {
    try {
      final response = await supabase.from('ikan').select('*');
      final List<IkanModel> loadedFish = response.map<IkanModel>((data) {
        return IkanModel(
          nama: data['nama'],
          namaIlmiah: data['nama_ilmiah'],
          gambarUrl: data['gambar_url'],
          deskripsi: data['deskripsi'],
          suhu: data['suhu'],
          jenis: data['jenis'],
          ph: data['ph'],
          oksigen: data['oksigen'],
          ukuran: data['ukuran'],
          umur: data['umur'],
          asal: data['asal'],
          kategori: data['kategori'],
        );
      }).toList();

      setState(() {
        _allFish = loadedFish;
        _filteredFish = loadedFish;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching fish data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredFish = _allFish.where((ikan) {
        return ikan.nama.toLowerCase().contains(keyword) ||
               ikan.namaIlmiah.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text("Cari Ikan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari ikan berdasarkan nama atau ilmiah...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFish.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ditemukan ikan 😔",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredFish.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final ikan = _filteredFish[index];
                          return _buildFishCard(ikan);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFishCard(IkanModel ikan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailIkanScreen(ikan: ikan),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ikan.gambarUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ikan.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ikan.namaIlmiah,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
