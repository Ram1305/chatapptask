import 'user.dart';

class ChatHistory {
  final User user;
  final String lastMessage;
  final DateTime lastChatTime;

  ChatHistory({
    required this.user,
    required this.lastMessage,
    required this.lastChatTime,
  });

  ChatHistory copyWith({
    User? user,
    String? lastMessage,
    DateTime? lastChatTime,
  }) {
    return ChatHistory(
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      lastChatTime: lastChatTime ?? this.lastChatTime,
    );
  }
}

