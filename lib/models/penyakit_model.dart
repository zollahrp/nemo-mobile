class PenyakitModel {
  final String id;
  final String nama;
  final String deskripsi;
  final String gejala;
  final String solusi;
  final String gambarUrl;

  PenyakitModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.gejala,
    required this.solusi,
    required this.gambarUrl,
  });

  factory PenyakitModel.fromMap(Map<String, dynamic> map) {
    return PenyakitModel(
      id: map['id'],
      nama: map['nama_penyakit'],
      deskripsi: map['deskripsi'],
      gejala: map['gejala'],
      solusi: map['solusi'],
      gambarUrl: map['gambar_url'] ?? '',
    );
  }
}