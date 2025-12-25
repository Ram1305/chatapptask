import 'package:equatable/equatable.dart';
import '../../models/message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatMessages extends ChatEvent {
  final List<Message> messages;

  const LoadChatMessages(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SendMessage extends ChatEvent {
  final String text;
  final String userId;

  const SendMessage(this.text, this.userId);

  @override
  List<Object?> get props => [text, userId];
}

class ReceiveMessage extends ChatEvent {
  final Message message;

  const ReceiveMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class SetLoading extends ChatEvent {
  final bool isLoading;

  const SetLoading(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

