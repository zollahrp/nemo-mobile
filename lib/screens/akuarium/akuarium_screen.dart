import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/akuarium/Set_Ecosystem_Screen.dart';
import 'package:nemo_mobile/screens/akuarium/detail_akuarium_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/akuarium_model.dart';


class AkuariumScreen extends StatefulWidget {
  const AkuariumScreen({super.key});

  @override
  State<AkuariumScreen> createState() => _AkuariumScreenState();
}

class _AkuariumScreenState extends State<AkuariumScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAkuarium();
  }

  Future<void> fetchAkuarium() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final res = await Supabase.instance.client
          .from('akuarium')
          .select()
          .eq('profiles_id', user!.id)
          .order('created_at');

      akuariumList = (res as List).map((e) => AkuariumModel.fromMap(e)).toList();
    } catch (e) {
      error = 'Gagal mengambil data akuarium';
    } finally {
      setState(() => isLoading = false);
    }
  }

  
  List<AkuariumModel> akuariumList = [];
  bool isLoading = true;
  String? error;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔷 HEADER
            _buildHeader(),

            // 🔷 TAB CONTENT
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAkuariumTab(),
                  _buildReminderTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetEcosystemScreen()),
          );
        },
        backgroundColor: const Color(0xFF0E91E9),
        label: const Text(
          'Tambah Akuarium',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE0F2FE),
      padding: const EdgeInsets.only(top: 8),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Akuarium Aku",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                 Text(
                  akuariumList.isEmpty
                      ? "Belum ada akuarium"
                      : "Total: ${akuariumList.length} Akuarium",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    dividerColor: Colors.transparent,
                    indicatorPadding: const EdgeInsets.all(2),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16), // 🔥 Tambah ini!
                    tabs: const [
                      Tab(child: Text("Semua Akuarium")),
                      Tab(child: Text("Pengingat")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAkuariumTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (akuariumList.isEmpty) {
      return const Center(child: Text("Belum ada akuarium"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: akuariumList.length,
      itemBuilder: (context, index) {
        final akuarium = akuariumList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAkuariumScreen(akuarium: akuarium),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: akuarium.fotoUrl != null
                          ? NetworkImage(akuarium.fotoUrl!)
                          : const AssetImage('lib/assets/images/fitur1.png') as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            akuarium.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 2),

                          if ((akuarium.jadwalPakan?.isEmpty ?? true) &&
                              (akuarium.jadwalMaintenance?.isEmpty ?? true))
                            const Text(
                              'Tidak ada pengingat yang diatur',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            )
                          else ...[
                            if ((akuarium.jadwalPakan?.isNotEmpty ?? false))
                              Text(
                                'Pakan: ${akuarium.jadwalPakan}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            if ((akuarium.jadwalMaintenance?.isNotEmpty ?? false))
                              Text(
                                'Maintenance: ${akuarium.jadwalMaintenance}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _iconCircle(Icons.thermostat),
                    const SizedBox(width: 12),
                    _iconCircle(Icons.build),
                    const SizedBox(width: 12),
                    _iconCircle(Icons.restaurant),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Helper widget untuk icon bulat
  Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Color(0xFF0E91E9), size: 16),
    );
  }

  Widget _buildReminderTab() {
    return const Center(child: Text("Belum ada pengingat ditambahkan."));
  }
}
