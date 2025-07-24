import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/screens/akuarium/akuarium_screen.dart';
import 'package:nemo_mobile/models/jadwal_model.dart';


class AturJadwalScreen extends StatefulWidget {
  final String type; // 'makan' atau 'maintenance'
  final String akuariumId;

  const AturJadwalScreen({
    super.key,
    required this.type,
    required this.akuariumId,
  });

  @override
  State<AturJadwalScreen> createState() => _AturJadwalScreenState();
}

class _AturJadwalScreenState extends State<AturJadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedTime != null && _selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final formattedTime = _selectedTime!.format(context);

      try {
        await Supabase.instance.client.from('jadwal').insert({
          'akuarium_id': widget.akuariumId,
          'type': widget.type,
          'tanggal': formattedDate,
          'jam': _selectedTime!.hour.toString().padLeft(2, '0') +
                ':' +
                _selectedTime!.minute.toString().padLeft(2, '0'),
          'created_at': DateTime.now().toIso8601String(),
        });

        // Navigasi ke AkuariumScreen setelah sukses
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AkuariumScreen()),
          (route) => false, // hapus semua route sebelumnya
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.type == 'makan' ? 'Atur Jadwal Pakan' : 'Atur Jadwal Maintenance';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pilih Tanggal", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih tanggal',
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Belum dipilih'
                        : DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Pilih Jam", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih jam',
                  ),
                  child: Text(
                    _selectedTime == null
                        ? 'Belum dipilih'
                        : _selectedTime!.format(context),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan Jadwal"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}