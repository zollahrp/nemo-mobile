import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nemo_mobile/models/chat_session.dart';
import 'package:nemo_mobile/models/message.dart';

class ChatService {
  final supabase = Supabase.instance.client;

  // CREATE Session
  Future<ChatSession?> createSession(String userId) async {
    final res = await supabase.from('chat_sessions').insert({
      'user_id': userId,
    }).select().single();

    return ChatSession.fromJson(res);
  }

  // GET All Sessions (by user)
  Future<List<ChatSession>> getSessions(String userId) async {
    final res = await supabase
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (res as List).map((json) => ChatSession.fromJson(json)).toList();
  }

  // DELETE Session
  Future<void> deleteSession(String sessionId) async {
    await supabase.from('chat_sessions').delete().eq('id', sessionId);
  }

  // CREATE Message
  Future<void> createMessage({
    required String sessionId,
    required String role,
    required String text,
  }) async {
    await supabase.from('chat_messages').insert({
      'session_id': sessionId,
      'role': role,
      'text': text,
    });
  }

  // GET Messages in Session
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final res = await supabase
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at');

    return (res as List).map((json) => ChatMessage.fromJson(json)).toList();
  }

  // DELETE Message
  Future<void> deleteMessage(String messageId) async {
    await supabase.from('chat_messages').delete().eq('id', messageId);
  }
}