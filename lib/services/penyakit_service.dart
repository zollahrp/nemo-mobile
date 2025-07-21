import 'package:nemo_mobile/models/penyakit_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<PenyakitModel>> getPenyakitByIkanId(String ikanId) async {
  final response = await supabase
      .from('ikan_penyakit')
      .select('penyakit(*)') 
      .eq('ikan_id', ikanId);

  if (response == null) return [];

  final data = response as List;
  return data.map((row) => PenyakitModel.fromMap(row['penyakit'])).toList();
}
