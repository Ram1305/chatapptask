import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../models/message.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class AddUser extends HomeEvent {
  final User user;

  const AddUser(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateMessages extends HomeEvent {
  final String userId;
  final List<Message> messages;

  const UpdateMessages(this.userId, this.messages);

  @override
  List<Object?> get props => [userId, messages];
}

class ChangeTab extends HomeEvent {
  final int tabIndex;

  const ChangeTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class ToggleSwitcher extends HomeEvent {
  final bool show;

  const ToggleSwitcher(this.show);

  @override
  List<Object?> get props => [show];
}

