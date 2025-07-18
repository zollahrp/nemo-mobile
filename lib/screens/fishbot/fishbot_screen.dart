import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FishBotScreen extends StatefulWidget {
  const FishBotScreen({super.key});

  @override
  State<FishBotScreen> createState() => _FishBotScreenState();
}

class _FishBotScreenState extends State<FishBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> sendMessage() async {
    final inputText = _controller.text;
    if (inputText.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': inputText});
      _controller.clear();
    });

    final apiKey = dotenv.env['GEMINI_API_KEY'];

    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/gemini-2.0-flash:generateContent',
      {'key': apiKey},
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
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

    if (response.statusCode != 200) {
      print('Error code: ${response.statusCode}');
      print('Response body: ${response.body}');
      setState(() {
        _messages.add({'role': 'bot', 'text': 'Terjadi kesalahan: ${response.statusCode}'});
      });
      return;
    }

    final result = json.decode(response.body);
    final reply = result['candidates']?[0]['content']?['parts']?[0]?['text'] ?? 'Gagal mendapatkan balasan.';

    setState(() {
      _messages.add({'role': 'bot', 'text': reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset('lib/assets/images/logo.png', width: 100),
            const SizedBox(height: 16),
            const Text(
              'Membutuhkan bantuan?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'AI kami siap membantu Kamu\nmasalah ikan hias apa pun!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const Divider(),

            // Chat list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['text'] ?? ''),
                    ),
                  );
                },
              ),
            ),

            // Input area
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
                        hintText: 'Ketik di sini...',
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
