import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tabler_icons/tabler_icons.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  final List<Widget> _pages = [
    Center(child: Text('Beranda', style: TextStyle(fontSize: 24))),
    Center(child: Text('Pencarian', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profil', style: TextStyle(fontSize: 24))),
  ];

  final List<IconData> icons = [
    TablerIcons.home,
    TablerIcons.search,
    TablerIcons.user,
  ];

  final List<String> labels = [
    'Beranda',
    'Cari',
    'Akun',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // biar efek transparan bisa jalan
      body: Stack(
        children: [
          _pages[_page],
          // Optional: Tambahin efek blur/glass di atas navigasi
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: Color(0xFF0E91E9),
        height: 65,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: List.generate(icons.length, (i) {
          final isActive = _page == i;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons[i],
                size: 28,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
              if (isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
