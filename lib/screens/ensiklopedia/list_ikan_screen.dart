import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/IkanModel.dart';
import 'detail_ikan_screen.dart';

class ListIkanScreen extends StatefulWidget {
  final String kategori;
  const ListIkanScreen({super.key, required this.kategori});

  @override
  State<ListIkanScreen> createState() => _ListIkanScreenState();
}

class _ListIkanScreenState extends State<ListIkanScreen> {
  final supabase = Supabase.instance.client;
  List<IkanModel> ikanList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchIkan();
  }

  Future<void> fetchIkan() async {
    final response = await supabase
        .from('ikan')
        .select()
        .eq('kategori', widget.kategori);

    final data = (response as List).map((e) => IkanModel.fromMap(e)).toList();
    setState(() {
      ikanList = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.kategori)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ikanList.isEmpty
              ? const Center(child: Text("Tidak ada data"))
              : ListView.builder(
                  itemCount: ikanList.length,
                  itemBuilder: (context, index) {
                    final ikan = ikanList[index];
                    return ListTile(
                      leading: Image.network(ikan.gambarUrl, width: 50, height: 50, fit: BoxFit.cover),
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
