import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/screens/akuarium/akuarium_screen.dart';
import 'package:nemo_mobile/screens/home/main_screen.dart';
import 'package:nemo_mobile/models/jadwal_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:nemo_mobile/utils/notifikasi.dart';


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

      try {
      // Simpan ke Supabase
      await Supabase.instance.client.from('jadwal').insert({
        'akuarium_id': widget.akuariumId,
        'type': widget.type,
        'tanggal': formattedDate,
        'jam': _selectedTime!.hour.toString().padLeft(2, '0') +
            ':' +
            _selectedTime!.minute.toString().padLeft(2, '0'),
        'created_at': DateTime.now().toIso8601String(),
      });

      // ✅ Tampilkan notifikasi langsung
      await showNowNotification(
        'Jadwal Ditambahkan',
        'Kamu baru saja menambahkan jadwal ${widget.type} untuk akuarium!',
      );

      final jadwalTz = tz.TZDateTime(
        tz.local,
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // ✅ Hitung waktu 5 menit sebelumnya
      final scheduledNotifTz = jadwalTz.subtract(const Duration(minutes: 5));

      // ✅ Ambil waktu sekarang untuk validasi
      final nowTz = tz.TZDateTime.now(tz.local);

      // ✅ Gunakan waktu notifikasi yang valid
      final validNotifTime = scheduledNotifTz.isBefore(nowTz) ? jadwalTz : scheduledNotifTz;
      // ✅ Jadwalkan notifikasi
      await scheduleNotification(
        title: 'Pengingat Jadwal ${widget.type}',
        body: 'Waktunya melakukan ${widget.type} untuk akuarium kamu!',
        scheduledTime: validNotifTime,
        id: jadwalTz.millisecondsSinceEpoch.remainder(100000),
      );

      // ✅ Kembali ke halaman akuarium
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 1)), // 👈 balik ke tab akuarium
        (route) => false,
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