import 'package:flutter/material.dart';
import 'package:nemo_mobile/screens/akuarium/Set_Ecosystem_Screen.dart';


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
  }

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
                const Text(
                  "Total: 1 Akuarium",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
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

  // 🔹 Dummy Content Akuarium
  Widget _buildAkuariumTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'lib/assets/images/fitur1.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aquariumku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Tidak ada pengingat yang diatur', style: TextStyle(fontSize: 13, color: Colors.grey)),
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
      ],
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
