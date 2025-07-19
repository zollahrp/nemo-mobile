import 'package:nemo_mobile/models/message.dart';

class ChatSession {
  final String id;
  final DateTime createdAt;
  final List<Message> messages;

  ChatSession({
    required this.id,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'],
    createdAt: DateTime.parse(json['createdAt']),
    messages: (json['messages'] as List)
        .map((m) => Message.fromJson(m))
        .toList(),
  );
}