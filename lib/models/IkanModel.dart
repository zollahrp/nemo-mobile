class IkanModel {
  final String nama;
  final String namaIlmiah;
  final String gambarUrl;
  final String deskripsi;
  final String suhu;
  final String jenis;
  final String ph;
  final String oksigen;
  final String ukuran;
  final String umur;
  final String asal;
  final String kategori;
  final double? tempMin;
  final double? tempMax;
  final double? phMin;
  final double? phMax;

  IkanModel({
    required this.nama,
    required this.namaIlmiah,
    required this.gambarUrl,
    required this.deskripsi,
    required this.suhu,
    required this.jenis,
    required this.ph,
    required this.oksigen,
    required this.ukuran,
    required this.umur,
    required this.asal,
    required this.kategori,
    this.tempMin,
    this.tempMax,
    this.phMin,
    this.phMax,
  });

  factory IkanModel.fromMap(Map<String, dynamic> map) {
    return IkanModel(
      nama: map['nama'],
      namaIlmiah: map['nama_ilmiah'],
      gambarUrl: map['gambar_url'],
      deskripsi: map['deskripsi'],
      suhu: map['suhu'],
      jenis: map['jenis'],
      ph: map['ph'],
      oksigen: map['oksigen'],
      ukuran: map['ukuran'],
      umur: map['umur'],
      asal: map['asal'],
      kategori: map['kategori'],
      tempMin: map['temp_min']?.toDouble(),
      tempMax: map['temp_max']?.toDouble(),
      phMin: map['ph_min']?.toDouble(),
      phMax: map['ph_max']?.toDouble(),
    );
  }
}
