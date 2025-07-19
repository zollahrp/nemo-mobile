import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/message.dart';
import '../../models/chat_session.dart';
import '../../shared/chat_storage.dart';
import '../../widgets/chat_bubble.dart';

class FishBotScreen extends StatefulWidget {
  const FishBotScreen({super.key});

  @override
  State<FishBotScreen> createState() => _FishBotScreenState();
}

class _FishBotScreenState extends State<FishBotScreen> {
  final TextEditingController _controller = TextEditingController();
  late String _sessionId;
  late List<ChatSession> _allSessions;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    _sessionId = 'session_default'; // sementara static dulu
    _allSessions = await ChatStorage.getSessions();

    final existing = _allSessions.firstWhere(
      (s) => s.id == _sessionId,
      orElse: () => ChatSession(
        id: _sessionId,
        createdAt: DateTime.now(),
        messages: [],
      ),
    );

    if (!_allSessions.any((s) => s.id == _sessionId)) {
      _allSessions.add(existing);
      await ChatStorage.saveSessions(_allSessions);
    }

    setState(() {
      _messages = existing.messages;
    });
  }

  Future<void> sendMessage() async {
    final inputText = _controller.text.trim();
    if (inputText.isEmpty) return;

    final userMessage = Message(role: 'user', text: inputText);
    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    _updateSessionMessages();

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/gemini-2.0-flash:generateContent',
      {'key': apiKey},
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": inputText}
            ]
          }
        ]
      }),
    );

    final replyText = (response.statusCode == 200)
        ? (json.decode(response.body)['candidates']?[0]['content']?['parts']?[0]?['text'] ?? 'Tidak ada jawaban.')
        : 'Terjadi kesalahan: ${response.statusCode}';

    final botMessage = Message(role: 'bot', text: replyText);
    setState(() => _messages.add(botMessage));

    _updateSessionMessages();
  }

  void _updateSessionMessages() async {
    final sessionIndex = _allSessions.indexWhere((s) => s.id == _sessionId);
    if (sessionIndex != -1) {
      _allSessions[sessionIndex] = ChatSession(
        id: _sessionId,
        createdAt: _allSessions[sessionIndex].createdAt,
        messages: _messages,
      );
      await ChatStorage.saveSessions(_allSessions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset('lib/assets/images/logo.png', width: 100),
            const SizedBox(height: 12),
            const Text(
              'Membutuhkan bantuan?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'AI kami siap bantu Kamu\nmasalah ikan hias apa pun!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const Divider(),

            // Chat list
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada percakapan.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        if (message.text.isEmpty || message.role.isEmpty) {
                          return const Text('[Pesan tidak valid]');
                        }
                        return ChatBubble(message: message);
                      },
                    ),
            ),

            // Input
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Ketik pertanyaan di sini...',
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import '../../models/message.dart';
// import '../../models/chat_session.dart';
// import '../../shared/chat_storage.dart';
// import '../../widgets/chat_bubble.dart';

// class FishBotScreen extends StatefulWidget {
//   const FishBotScreen({super.key});

//   @override
//   State<FishBotScreen> createState() => _FishBotScreenState();
// }

// // class FishBotScreen extends StatefulWidget {
// //   final String sessionId;

// //   const FishBotScreen({super.key, required this.sessionId});

// //   @override
// //   State<FishBotScreen> createState() => _FishBotScreenState();
// // }

// class _FishBotScreenState extends State<FishBotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   late String _sessionId;
//   late List<ChatSession> _allSessions;
//   List<Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _initChat();
//   }

//   Future<void> _initChat() async {
//     _sessionId = widget.sessionId; // ✅ akses sessionId dari widget

//     _allSessions = await ChatStorage.getSessions();

//     final existing = _allSessions.firstWhere(
//       (s) => s.id == _sessionId,
//       orElse: () => ChatSession(
//         id: _sessionId,
//         createdAt: DateTime.now(),
//         messages: [],
//       ),
//     );

//     if (!_allSessions.any((s) => s.id == _sessionId)) {
//       _allSessions.add(existing);
//       await ChatStorage.saveSessions(_allSessions);
//     }

//     setState(() {
//       _messages = existing.messages;
//     });
//   }

//   Future<void> sendMessage() async {
//     final inputText = _controller.text.trim();
//     if (inputText.isEmpty) return;

//     final userMessage = Message(role: 'user', text: inputText);
//     setState(() {
//       _messages.add(userMessage);
//       _controller.clear();
//     });

//     _updateSessionMessages();

//     final apiKey = dotenv.env['GEMINI_API_KEY'];
//     final uri = Uri.https(
//       'generativelanguage.googleapis.com',
//       '/v1beta/models/gemini-2.0-flash:generateContent',
//       {'key': apiKey},
//     );

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "contents": [
//           {
//             "role": "user",
//             "parts": [
//               {"text": inputText}
//             ]
//           }
//         ]
//       }),
//     );

//     final replyText = (response.statusCode == 200)
//         ? (json.decode(response.body)['candidates']?[0]['content']?['parts']?[0]?['text'] ?? 'Tidak ada jawaban.')
//         : 'Terjadi kesalahan: ${response.statusCode}';

//     final botMessage = Message(role: 'bot', text: replyText);
//     setState(() => _messages.add(botMessage));

//     _updateSessionMessages();
//   }

//   void _updateSessionMessages() async {
//     final sessionIndex = _allSessions.indexWhere((s) => s.id == _sessionId);
//     if (sessionIndex != -1) {
//       _allSessions[sessionIndex] = ChatSession(
//         id: _sessionId,
//         createdAt: _allSessions[sessionIndex].createdAt,
//         messages: _messages,
//       );
//       await ChatStorage.saveSessions(_allSessions);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             Image.asset('lib/assets/images/logo.png', width: 100),
//             const SizedBox(height: 12),
//             const Text(
//               'Membutuhkan bantuan?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const Text(
//               'AI kami siap bantu Kamu\nmasalah ikan hias apa pun!',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black54),
//             ),
//             const Divider(),

//             // Chat list
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'Belum ada percakapan.',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final message = _messages[index];
//                         if (message.text.isEmpty || message.role.isEmpty) {
//                           return const Text('[Pesan tidak valid]');
//                         }
//                         return ChatBubble(message: message);
//                       },
//                     ),
//             ),

//             // Input
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Ketik pertanyaan di sini...',
//                       ),
//                       onSubmitted: (_) => sendMessage(),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
