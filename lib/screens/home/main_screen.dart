import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nemo_mobile/screens/home/home_screen.dart';
import 'package:nemo_mobile/screens/scanner/scanner_screen.dart';
import 'package:nemo_mobile/screens/fishbot/fishbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime? _lastPressed; // Tambahkan ini

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScannerScreen(),
    const FishBotScreen(),
  ];

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
        return true; // keluar aplikasi
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: PhysicalModel(
          color: Colors.transparent,
          elevation: 12,
          shadowColor: Colors.black.withOpacity(0.3),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            buttonBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            height: 60,
            index: _selectedIndex,
            items: const <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Icon(Icons.home, size: 30, color: Color(0xFF0E91E9),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.qr_code_scanner, size: 30, color: Color(0xFF0E91E9),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.auto_awesome, size: 30, color: Color(0xFF0E91E9),),
              ),
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
