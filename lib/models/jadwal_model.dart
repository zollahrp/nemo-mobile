class JadwalModel {
  final String id;
  final String akuariumId;
  final String type; // 'makan' atau 'maintenance'
  final DateTime tanggal;
  final String jam; // format 'HH:mm' atau pakai TimeOfDay.toString()
  final DateTime createdAt;

  JadwalModel({
    required this.id,
    required this.akuariumId,
    required this.type,
    required this.tanggal,
    required this.jam,
    required this.createdAt,
  });

  factory JadwalModel.fromMap(Map<String, dynamic> map) {
    return JadwalModel(
      id: map['id'],
      akuariumId: map['akuarium_id'],
      type: map['type'],
      tanggal: DateTime.parse(map['tanggal']),
      jam: map['jam'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'akuarium_id': akuariumId,
      'type': type,
      'tanggal': tanggal.toIso8601String().split('T').first, // format YYYY-MM-DD
      'jam': jam,
      'created_at': createdAt.toIso8601String(),
    };
  }
}