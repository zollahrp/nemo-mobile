import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart'; // pastikan import model Message

class ChatStorage {
  static const String _key = 'chat_messages';

  // Simpan list Message ke SharedPreferences
  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(messages.map((m) => m.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  // Ambil list Message dari SharedPreferences
  static Future<List<Message>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];

    final decoded = json.decode(data) as List<dynamic>;
    return decoded.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // Hapus semua pesan
  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
