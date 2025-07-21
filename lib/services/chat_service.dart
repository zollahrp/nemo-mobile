import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_session_model.dart';
import '../models/chat_message_model.dart';
import 'package:flutter/foundation.dart';

final supabase = Supabase.instance.client;

class ChatService {
  static Future<ChatSession> createSession(String? userId) async {
    final res = await supabase.from('chat_sessions').insert({
      'user_id': userId,
      'title': 'Sesi ${DateTime.now().toIso8601String()}',
    }).select().single();

    return ChatSession.fromJson(res);
  }

  static Future<List<ChatMessage>> getMessages(String sessionId) async {
    final res = await supabase
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);

    return (res as List)
        .map((msg) => ChatMessage.fromJson(msg))
        .toList();
  }

  static Future<void> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    try {
      debugPrint('[SEND] session_id: $sessionId, role: $role, content: $content');
      await supabase.from('chat_messages').insert({
        'session_id': sessionId,
        'role': role,
        'content': content,
      });
    } catch (e) {
      debugPrint('Gagal kirim ke Supabase: $e');
    }
  }

  static Future<ChatSession?> getLastSession(String? userId) async {
    if (userId == null) return null;

    final res = await supabase
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return res != null ? ChatSession.fromJson(res) : null;
  }

    static Future<List<ChatSession>> getSessions(String? userId) async {
    if (userId == null) return [];

    final res = await supabase
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (res as List)
        .map((session) => ChatSession.fromJson(session))
        .toList();
  }
  static Future<List<ChatSession>> getAllSessions(String userId) async {
    final res = await supabase
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (res as List).map((s) => ChatSession.fromJson(s)).toList();
  }
  static Future<void> deleteSessionWithMessages(String sessionId) async {
    try {
      // Hapus pesan
      await supabase
          .from('chat_messages')
          .delete()
          .eq('session_id', sessionId);

      // Hapus sesi
      await supabase
          .from('chat_sessions')
          .delete()
          .eq('id', sessionId);
    } catch (e) {
      debugPrint('Gagal menghapus sesi: $e');
      throw Exception('Gagal menghapus sesi: $e');
    }
  }
  static Future<ChatSession?> getSessionById(String sessionId) async {
    final response = await Supabase.instance.client
        .from('chat_sessions')
        .select()
        .eq('id', sessionId)
        .maybeSingle();

    if (response == null) return null;

    return ChatSession.fromJson(response);
  }
}
