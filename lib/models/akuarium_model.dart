class AkuariumModel {
  final String id;
  final String profilesId;
  final String nama;
  final String? fotoUrl;
  final int jumlahIkan;
  final String? ikanId;
  final double? temperature;
  final double? ph;
  final double? tankSizeL;
  final bool isFavorite;
  final bool isSetMode;
  final String? jadwalPakan;
  final String? jadwalMaintenance;
  final DateTime createdAt;

  AkuariumModel({
    required this.id,
    required this.profilesId,
    required this.nama,
    this.fotoUrl,
    required this.jumlahIkan,
    this.ikanId,
    this.temperature,
    this.ph,
    this.tankSizeL,
    this.isFavorite = false,
    this.isSetMode = false,
    this.jadwalPakan,
    this.jadwalMaintenance,
    required this.createdAt,
  });

  factory AkuariumModel.fromMap(Map<String, dynamic> map) {
    return AkuariumModel(
      id: map['id'],
      profilesId: map['profiles_id'],
      nama: map['nama'],
      fotoUrl: map['foto_url'],
      jumlahIkan: map['jumlah_ikan'] ?? 0,
      ikanId: map['ikan_id'],
      temperature: (map['temperature'] as num?)?.toDouble(),
      ph: (map['ph'] as num?)?.toDouble(),
      tankSizeL: (map['tank_size_l'] as num?)?.toDouble(),
      isFavorite: map['is_favorite'] ?? false,
      isSetMode: map['is_set_mode'] ?? false,
      jadwalPakan: map['jadwal_pakan'],
      jadwalMaintenance: map['jadwal_maintenance'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profiles_id': profilesId,
      'nama': nama,
      'foto_url': fotoUrl,
      'jumlah_ikan': jumlahIkan,
      'ikan_id': ikanId,
      'temperature': temperature,
      'ph': ph,
      'tank_size_l': tankSizeL,
      'is_favorite': isFavorite,
      'is_set_mode': isSetMode,
      'jadwal_pakan': jadwalPakan,
      'jadwal_maintenance': jadwalMaintenance,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
