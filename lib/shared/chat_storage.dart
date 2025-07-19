import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_session.dart';

class ChatStorage {
  static const String key = 'chat_sessions';

  static Future<List<ChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);
    return decoded.map((item) => ChatSession.fromJson(item)).toList();
  }

  static Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(key, jsonString);
  }
}
