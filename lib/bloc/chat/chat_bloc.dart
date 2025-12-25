import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/message.dart';
import '../../services/api_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<SetLoading>(_onSetLoading);
  }

  void _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoaded(messages: event.messages));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final userMessage = Message(
        text: event.text,
        isSender: true,
        timestamp: DateTime.now(),
        userId: event.userId,
      );

      final updatedMessages = List<Message>.from(currentState.messages)
        ..add(userMessage);

      emit(currentState.copyWith(
        messages: updatedMessages,
        isLoading: true,
      ));

    
      final apiMessage = await ApiService.getRandomMessage();
      final receiverMessage = Message(
        text: apiMessage,
        isSender: false,
        timestamp: DateTime.now(),
        userId: event.userId,
      );

      final finalMessages = List<Message>.from(updatedMessages)
        ..add(receiverMessage);

      emit(currentState.copyWith(
        messages: finalMessages,
        isLoading: false,
      ));
    }
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedMessages = List<Message>.from(currentState.messages)
        ..add(event.message);
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _onSetLoading(
    SetLoading event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(isLoading: event.isLoading));
    }
  }
}

