import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../models/message.dart';
import '../../models/chat_history.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<User> users;
  final Map<String, List<Message>> allMessages;
  final int selectedTab;
  final bool showSwitcher;

  const HomeLoaded({
    required this.users,
    required this.allMessages,
    this.selectedTab = 0,
    this.showSwitcher = true,
  });

  List<ChatHistory> get chatHistory {
    return users.where((user) {
      final messages = allMessages[user.id] ?? [];
      return messages.isNotEmpty;
    }).map((user) {
      final messages = allMessages[user.id]!;
      final lastMsg = messages.last;
      return ChatHistory(
        user: user,
        lastMessage: lastMsg.text,
        lastChatTime: lastMsg.timestamp,
      );
    }).toList()
      ..sort((a, b) => b.lastChatTime.compareTo(a.lastChatTime));
  }

  HomeLoaded copyWith({
    List<User>? users,
    Map<String, List<Message>>? allMessages,
    int? selectedTab,
    bool? showSwitcher,
  }) {
    return HomeLoaded(
      users: users ?? this.users,
      allMessages: allMessages ?? this.allMessages,
      selectedTab: selectedTab ?? this.selectedTab,
      showSwitcher: showSwitcher ?? this.showSwitcher,
    );
  }

  @override
  List<Object?> get props => [users, allMessages, selectedTab, showSwitcher];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

