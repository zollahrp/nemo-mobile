import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart';
import '../models/chat_session.dart'; // tambahkan ini

class ChatStorage {
  static const _keyMessages = 'chat_messages';
  static const _keySessions = 'chat_sessions';

  // ------------------ MESSAGE ------------------

  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(messages.map((m) => m.toJson()).toList());
    await prefs.setString(_keyMessages, encoded);
  }

  static Future<List<Message>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyMessages);
    if (data == null) return [];
    final decoded = json.decode(data) as List<dynamic>;
    return decoded.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMessages);
  }

  // ------------------ CHAT SESSION ------------------

  static Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_keySessions, data);
  }

  static Future<List<ChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_keySessions) ?? [];
    return data.map((s) => ChatSession.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> deleteSession(String id) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == id);
    await saveSessions(sessions);
  }

  static Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessions);
  }
}
