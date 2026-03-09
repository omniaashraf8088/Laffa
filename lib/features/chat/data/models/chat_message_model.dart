class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });

  ChatMessage copyWith({String? text, bool? isUser, DateTime? time}) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
    );
  }
}
