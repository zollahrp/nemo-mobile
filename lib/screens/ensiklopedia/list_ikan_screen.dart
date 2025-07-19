import 'package:flutter/material.dart';
import 'detail_ikan_screen.dart';
import '../../models/ikanmodel.dart';

class ListIkanScreen extends StatelessWidget {
  final String kategori;

  const ListIkanScreen({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final List<IkanModel> ikanList = [
      IkanModel(
        nama: 'Ikan Mas',
        namaIlmiah: 'Cyprinus carpio',
        gambarUrl: 'lib/assets/images/ikan_mas.jpg',
        deskripsi: 'Ikan Mas adalah ikan air tawar yang populer di budidaya dan konsumsi.',
        suhu: '20°C~28°C',
        jenis: 'Omnivora',
        ygLain: 'Habitat sungai dan kolam',
      ),
      IkanModel(
        nama: 'Ikan Nila',
        namaIlmiah: 'Oreochromis niloticus',
        gambarUrl: 'lib/assets/images/ikan_nila.jpg',
        deskripsi: 'Ikan Nila adalah ikan konsumsi yang banyak dibudidayakan di Indonesia.',
        suhu: '25°C~30°C',
        jenis: 'Herbivora',
        ygLain: 'Asal dari Afrika',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(kategori)),
      body: ListView.builder(
        itemCount: ikanList.length,
        itemBuilder: (context, index) {
          final ikan = ikanList[index];
          return ListTile(
            leading: Image.asset(ikan.gambarUrl),
            title: Text(ikan.nama),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailIkanScreen(ikan: ikan),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
