// import 'package:nemo_mobile/models/message.dart';

// class ChatSession {
//   final String id;
//   final String userId;
//   final DateTime createdAt;
//   final List<Message> messages;

//   ChatSession({
//     required this.id,
//     required this.userId,
//     required this.createdAt,
//     required this.messages,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'user_id': userId,
//         'created_at': createdAt.toIso8601String(),
//         'messages': messages.map((m) => m.toJson()).toList(),
//       };

//   factory ChatSession.fromJson(Map<String, dynamic> json) {
//     return ChatSession(
//       id: json['id'],
//       userId: json['user_id'],
//       createdAt: DateTime.parse(json['created_at']),
//       messages: json['messages'] != null
//           ? (json['messages'] as List)
//               .map((m) => Message.fromJson(m))
//               .toList()
//           : [],
//     );
//   }
// }
