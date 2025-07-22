import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/chat_bubble.dart';
import '../../models/chat_session_model.dart';
import 'package:nemo_mobile/screens/fishbot/history_screen.dart';
import '../../models/chat_message_model.dart';
import '../../services/chat_service.dart';

class FishBotScreen extends StatefulWidget {
  final String? sessionId;

  const FishBotScreen({super.key, this.sessionId});

  @override
  State<FishBotScreen> createState() => _FishBotScreenState();
}

class _FishBotScreenState extends State<FishBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatSession? currentSession;
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (widget.sessionId != null) {
      final session = await ChatService.getSessionById(widget.sessionId!);
      setState(() => currentSession = session);
    } else {
      var last = await ChatService.getLastSession(userId);
      last ??= await ChatService.createSession(userId);
      setState(() => currentSession = last);
    }

    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (currentSession == null) return;
    final msgs = await ChatService.getMessages(currentSession!.id);
    setState(() => _messages = msgs);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut, // sebelumnya Curves.easeOut
        );
      }
    });
  }

  Future<void> sendMessage([String? customText]) async {
    final inputText = (customText ?? _controller.text).trim();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (inputText.isEmpty || currentSession == null || userId == null) return;

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
      _isTyping = true; 
    });
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));

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
              "parts": [{"text": inputText}]
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

      setState(() {
        _isTyping = false;
      });
      _loadMessages();
    } catch (_) {
      await ChatService.sendMessage(
        sessionId: currentSession!.id,
        role: 'assistant',
        content: 'Terjadi error saat menghubungi AI.',
      );
      setState(() => _isTyping = false);
      _loadMessages();
    }
  }

  final List<String> quickSuggestions = [
    "Rekomendasi ikan untuk pemula 🐠",
    "Cara merawat akuarium air tawar 🌿",
    "Penyakit umum ikan dan solusinya 💊",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset('lib/assets/images/logo.png', width: 90),
            const SizedBox(height: 8),
            const Text(
              'Butuh Bantuan Ikan Hias?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Tanyakan apapun ke Fishbot ✨',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF45B1F9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
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
                    child: const Text('Riwayat', style: TextStyle(color: Color(0xFF45B1F9))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 0),
            

            // Chat
            Expanded(
              child: Column(
                children: [
                  // List bubble chat atau quick suggestions
                  Expanded(
                    child: _messages.isEmpty
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coba pertanyaan ini:',
                                  style: TextStyle(fontSize: 14.5, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: quickSuggestions.map((suggestion) {
                                    return ActionChip(
                                      label: Text(suggestion),
                                      backgroundColor: const Color(0xFFE3F2FD),
                                      shape: StadiumBorder(
                                        side: BorderSide(color: Colors.blue.shade100),
                                      ),
                                      onPressed: () {
                                        _controller.text = suggestion;
                                        sendMessage(suggestion);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemCount: _messages.length + (_isTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isTyping) {
                                return const TypingIndicatorBubble();
                              }
                              return ChatBubble(message: _messages[index]);
                            },
                          ),
                  ),

                  // Input Field
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Ketik pertanyaan di sini...',
                              filled: true,
                              fillColor: const Color(0xFFF0F8FF),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: sendMessage,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF45B1F9),
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
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



class TypingIndicatorBubble extends StatefulWidget {
  const TypingIndicatorBubble({super.key});

  @override
  State<TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<TypingIndicatorBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)..repeat();
    _dotAnimation = Tween<double>(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getDots() {
    final dots = '.' * (_dotAnimation.value.floor() + 1);
    return dots.padRight(3, '.');
  }

  @override
    Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotAnimation,
      builder: (context, child) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Fishbot sedang mengetik${getDots()}',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        );
      },
    );
  }
}