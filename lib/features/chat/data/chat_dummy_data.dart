import 'models/chat_message_model.dart';

final List<ChatMessage> initialMessages = [
  ChatMessage(
    text: 'Hello! How can I help you today?',
    isUser: false,
    time: DateTime(2026, 3, 8, 10, 0),
  ),
  ChatMessage(
    text: 'I have a question about my last ride.',
    isUser: true,
    time: DateTime(2026, 3, 8, 10, 1),
  ),
  ChatMessage(
    text:
        'Sure! I\'d be happy to help. Could you please share the trip details or any issue you faced?',
    isUser: false,
    time: DateTime(2026, 3, 8, 10, 1, 30),
  ),
  ChatMessage(
    text:
        'The trip duration seems incorrect. It showed 45 minutes but I only rode for 20 minutes.',
    isUser: true,
    time: DateTime(2026, 3, 8, 10, 2),
  ),
  ChatMessage(
    text:
        'I understand your concern. Let me check your trip history. Could you provide the trip date?',
    isUser: false,
    time: DateTime(2026, 3, 8, 10, 3),
  ),
];
