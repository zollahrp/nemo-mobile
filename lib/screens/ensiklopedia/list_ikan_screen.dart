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
        appBar: AppBar(
          title: Text(widget.kategori),
          backgroundColor: const Color(0xFF45B1F9),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ikanList.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ikanList.length,
                    itemBuilder: (context, index) {
                      final ikan = ikanList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailIkanScreen(ikan: ikan),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  ikan.gambarUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ikan.nama,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ikan.namaIlmiah,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${ikan.deskripsi.split(' ').take(10).join(' ')}...',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      );
    }
}
