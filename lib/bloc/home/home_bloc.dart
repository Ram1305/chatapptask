import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';
import '../../models/message.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<AddUser>(_onAddUser);
    on<UpdateMessages>(_onUpdateMessages);
    on<ChangeTab>(_onChangeTab);
    on<ToggleSwitcher>(_onToggleSwitcher);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      
      final apiUsers = await ApiService.fetchUsersFromComments();
      final apiMessages = await ApiService.fetchMessagesFromComments();
      
      final savedUsers = await StorageService.loadUsers();
      final Map<String, List<Message>> savedMessages = {};
      for (var user in savedUsers) {
        savedMessages[user.id] = await StorageService.loadMessages(user.id);
      }
     
      final Map<String, User> usersMap = {};
      for (var user in apiUsers) {
        usersMap[user.id] = user;
      }
      for (var user in savedUsers) {
        if (!usersMap.containsKey(user.id)) {
          usersMap[user.id] = user;
        }
      }
      

      final Map<String, List<Message>> allMessages = Map.from(apiMessages);
      for (var entry in savedMessages.entries) {
        if (allMessages.containsKey(entry.key)) {
        
          allMessages[entry.key] = [
            ...allMessages[entry.key]!,
            ...entry.value,
          ]..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        } else {
          allMessages[entry.key] = entry.value;
        }
      }
      
   
      await StorageService.saveUsers(usersMap.values.toList());
      for (var entry in allMessages.entries) {
        await StorageService.saveMessages(entry.key, entry.value);
      }
      
      emit(HomeLoaded(
        users: usersMap.values.toList(),
        allMessages: allMessages,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onAddUser(
    AddUser event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedUsers = List<User>.from(currentState.users)..add(event.user);
      await StorageService.saveUsers(updatedUsers);
      emit(currentState.copyWith(users: updatedUsers));
    }
  }

  Future<void> _onUpdateMessages(
    UpdateMessages event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedMessages = Map<String, List<Message>>.from(currentState.allMessages);
      updatedMessages[event.userId] = event.messages;
      await StorageService.saveMessages(event.userId, event.messages);
      emit(currentState.copyWith(allMessages: updatedMessages));
    }
  }

  void _onChangeTab(
    ChangeTab event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedTab: event.tabIndex));
    }
  }

  void _onToggleSwitcher(
    ToggleSwitcher event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showSwitcher: event.show));
    }
  }
}

