// class Message {
//   final String role;
//   final String text;

//   Message({required this.role, required this.text});

//   Map<String, String> toJson() => {
//         'role': role,
//         'text': text,
//       };

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       role: json['role'] ?? '',
//       text: json['text'] ?? '',
//     );
//   }
// }

// class ChatMessage {
//   final String id;
//   final String sessionId;
//   final String role; // 'user' atau 'bot'
//   final String text;
//   final DateTime createdAt;

//   ChatMessage({
//     required this.id,
//     required this.sessionId,
//     required this.role,
//     required this.text,
//     required this.createdAt,
//   });

//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     return ChatMessage(
//       id: json['id'],
//       sessionId: json['session_id'],
//       role: json['role'],
//       text: json['text'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
