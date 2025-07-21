import 'package:flutter/material.dart';
import 'package:nemo_mobile/services/chat_service.dart';
import 'package:nemo_mobile/screens/fishbot/fishbot_screen.dart';
import 'package:nemo_mobile/models/chat_session_model.dart';

class ChatHistoryScreen extends StatefulWidget {
  final String? userId;
  const ChatHistoryScreen({super.key, required this.userId});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<ChatSession> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    final data = await ChatService.getSessions(widget.userId);
    setState(() {
      sessions = data;
      isLoading = false;
    });
  }

  Future<void> _confirmDeleteSession(String sessionId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah kamu yakin ingin menghapus riwayat ini? Semua pesan di dalamnya juga akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ChatService.deleteSessionWithMessages(sessionId);
      fetchSessions(); // refresh list setelah dihapus
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Chat")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
              ? const Center(child: Text("Belum ada riwayat chat"))
              : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(session.title ?? "Tanpa Judul"),
                      subtitle: Text(
                        session.createdAt?.toLocal().toString() ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDeleteSession(session.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FishBotScreen(sessionId: session.id),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
