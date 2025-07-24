import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nemo_mobile/screens/home/home_screen.dart';
import 'package:nemo_mobile/screens/akuarium/akuarium_screen.dart';
import 'package:nemo_mobile/screens/scanner/scanner_screen.dart';
import 'package:nemo_mobile/screens/ensiklopedia/list_ikan_screen.dart';
import 'package:nemo_mobile/screens/fishbot/fishbot_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  DateTime? _lastPressed;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const HomeScreen(),
    const AkuariumScreen(),
    const ScannerScreen(),
    const ListIkanScreen(),
    const FishBotScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tekan sekali lagi untuk keluar"),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: _screens[_selectedIndex],
        bottomNavigationBar: PhysicalModel(
          color: Colors.transparent,
          elevation: 12,
          shadowColor: Colors.black.withOpacity(0.3),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            height: 60,
            index: _selectedIndex,
            items: const <Widget>[
              Icon(Icons.home, size: 30, color: Color(0xFF0E91E9)),
              Icon(Icons.eco_rounded, size: 30, color: Color(0xFF0E91E9)),
              Icon(Icons.qr_code_scanner, size: 30, color: Color(0xFF0E91E9)),
              Icon(Icons.menu_book_rounded, size: 30, color: Color(0xFF0E91E9)),
              Icon(Icons.auto_awesome, size: 30, color: Color(0xFF0E91E9)),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}
