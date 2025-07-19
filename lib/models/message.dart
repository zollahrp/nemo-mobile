class Message {
  final String role;
  final String text;

  Message({required this.role, required this.text});

  Map<String, String> toJson() => {
        'role': role,
        'text': text,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
