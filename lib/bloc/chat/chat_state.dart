import 'package:equatable/equatable.dart';
import '../../models/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  final List<Message> messages;
  final bool isLoading;

  const ChatLoading({
    required this.messages,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [messages, isLoading];
}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isLoading;

  const ChatLoaded({
    required this.messages,
    this.isLoading = false,
  });

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isLoading,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading];
}

class ChatError extends ChatState {
  final String message;
  final List<Message> messages;

  const ChatError(this.message, this.messages);

  @override
  List<Object?> get props => [message, messages];
}

