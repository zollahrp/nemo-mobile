// import 'package:flutter/material.dart';
// import '../../models/chat_session.dart';
// import '../../shared/chat_storage.dart';
// import '../fishbot/fishbot_screen.dart';

// class ChatSessionListScreen extends StatefulWidget {
//   const ChatSessionListScreen({super.key});

//   @override
//   State<ChatSessionListScreen> createState() => _ChatSessionListScreenState();
// }

// class _ChatSessionListScreenState extends State<ChatSessionListScreen> {
//   List<ChatSession> _sessions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSessions();
//   }

//   Future<void> _loadSessions() async {
//     final data = await ChatStorage.getSessions();
//     setState(() => _sessions = data);
//   }

//   void _createNewSession() async {
//     final newSession = ChatSession(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       createdAt: DateTime.now(),
//       messages: [],
//     );

//     final updated = [..._sessions, newSession];
//     await ChatStorage.saveSessions(updated);

//     if (!mounted) return;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FishBotScreen(sessionId: newSession.id),
//       ),
//     );
//   }

//   void _openSession(ChatSession session) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FishBotScreen(sessionId: session.id),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Histori Chat')),
//       body: _sessions.isEmpty
//           ? const Center(child: Text('Belum ada sesi.'))
//           : ListView.builder(
//               itemCount: _sessions.length,
//               itemBuilder: (context, index) {
//                 final session = _sessions[index];
//                 final preview = session.messages.isNotEmpty
//                     ? session.messages.last.text
//                     : '[Kosong]';

//                 return ListTile(
//                   title: Text('Sesi ${index + 1}'),
//                   subtitle: Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () => _openSession(session),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _createNewSession,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
