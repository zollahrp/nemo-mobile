import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/chat_bubble.dart';
import '../../models/chat_session_model.dart';
import 'package:nemo_mobile/screens/fishbot/history_screen.dart';
import '../../models/chat_message_model.dart';
import '../../services/chat_service.dart';

// class FishBotScreen extends StatefulWidget {
//   const FishBotScreen({super.key});

//   @override
//   State<FishBotScreen> createState() => _FishBotScreenState();
// }

class FishBotScreen extends StatefulWidget {
  final String? sessionId; // tambahkan ini

  const FishBotScreen({super.key, this.sessionId});

  @override
  State<FishBotScreen> createState() => _FishBotScreenState();
}

class _FishBotScreenState extends State<FishBotScreen> {
  final TextEditingController _controller = TextEditingController();
  ChatSession? currentSession;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  // Future<void> _loadSession() async {
  //   final userId = Supabase.instance.client.auth.currentUser?.id;

  //   var last = await ChatService.getLastSession(userId);

  //   if (last == null) {
  //     last = await ChatService.createSession(userId);
  //   }

  //   setState(() {
  //     currentSession = last;
  //   });

  //   _loadMessages();
  // }

Future<void> _loadSession() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (widget.sessionId != null) {
    // load session lama
    final session = await ChatService.getSessionById(widget.sessionId!);
    setState(() {
      currentSession = session;
    });
  } else {
    // kalau nggak ada, buat baru
    var last = await ChatService.getLastSession(userId);
    last ??= await ChatService.createSession(userId);
    setState(() {
      currentSession = last;
    });
  }

  _loadMessages();
}

  Future<void> _loadMessages() async {
    if (currentSession == null) return;

    final msgs = await ChatService.getMessages(currentSession!.id);
    setState(() {
      _messages = msgs;
    });
  }

  Future<void> sendMessage() async {
    final inputText = _controller.text.trim();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    debugPrint('Kirim message: $inputText');

    if (inputText.isEmpty || currentSession == null || userId == null) {
      debugPrint('Gagal kirim pesan: input kosong atau user belum login.');
      return;
    }

    // Simpan pesan user
    await ChatService.sendMessage(
      sessionId: currentSession!.id,
      role: 'user',
      content: inputText,
    );

    setState(() {
      _messages.add(ChatMessage(
        id: '',
        role: 'user',
        content: inputText,
        createdAt: DateTime.now(),
      ));
      _controller.clear();
    });

    // Kirim ke Gemini
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/gemini-2.0-flash:generateContent',
      {'key': apiKey},
    );

    try {
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

      await ChatService.sendMessage(
        sessionId: currentSession!.id,
        role: 'assistant',
        content: replyText,
      );

      _loadMessages();
    } catch (e) {
      await ChatService.sendMessage(
        sessionId: currentSession!.id,
        role: 'assistant',
        content: 'Terjadi error saat menghubungi AI.',
      );
      _loadMessages();
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final userId = Supabase.instance.client.auth.currentUser?.id;
                      if (userId == null) return;

                      final newSession = await ChatService.createSession(userId);
                      setState(() {
                        currentSession = newSession;
                        _messages = [];
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Chat'),
                  ),
                  TextButton(
                    onPressed: () {
                      final userId = Supabase.instance.client.auth.currentUser?.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatHistoryScreen(userId: userId),
                        ),
                      );
                    },
                    child: const Text('History'),
                  )
                ],
              ),
            ),

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
                        return ChatBubble(message: message);
                      },
                    ),
            ),

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
