// lib/screens/ensiklopedia/list_ikan_screen.dart
import 'package:flutter/material.dart';
import 'detail_ikan_screen.dart';

class ListIkanScreen extends StatelessWidget {
  final String kategori;

  const ListIkanScreen({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final List<Map<String, String>> ikanList = [
      {'nama': 'Ikan Mas', 'gambar': 'lib/assets/images/ikan_mas.jpg'},
      {'nama': 'Ikan Nila', 'gambar': 'lib/assets/images/ikan_nila.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
      ),
      body: ListView.builder(
        itemCount: ikanList.length,
        itemBuilder: (context, index) {
          final ikan = ikanList[index];
          return ListTile(
            leading: Image.asset(ikan['gambar']!),
            title: Text(ikan['nama']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailIkanScreen(namaIkan: ikan['nama']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
