import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';
import '../widgets/user_list_item.dart';
import '../widgets/chat_history_item.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _usersScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeData());
    _usersScrollController.addListener(_onScroll);
    _historyScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      final controller = state.selectedTab == 0
          ? _usersScrollController
          : _historyScrollController;
      if (!controller.hasClients) return;
      
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (state.showSwitcher) {
          context.read<HomeBloc>().add(const ToggleSwitcher(false));
        }
      } else if (controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!state.showSwitcher) {
          context.read<HomeBloc>().add(const ToggleSwitcher(true));
        }
      }
    }
  }

  void _addUser() {
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '${AppConstants.appName} ${state.users.length + 1}',
        isOnline: false,
      );
      context.read<HomeBloc>().add(AddUser(newUser));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newUser.name} added'),
          behavior: SnackBarBehavior.floating,
          duration: AppConstants.snackBarDuration,
        ),
      );
    }
  }

  Future<void> _navigateToChat(User user, List<Message> messages) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          user: user,
          initialMessages: messages,
        ),
      ),
    );
    if (result != null && result is List<Message>) {
      context.read<HomeBloc>().add(UpdateMessages(user.id, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HomeError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        if (state is HomeLoaded) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(state.showSwitcher ? 110 : 56),
              child: AnimatedContainer(
                duration: AppConstants.animationDuration,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.appBarBackground,
                  title: const Text('Home', style: AppTextStyles.appBarTitle),
                  centerTitle: false,
                  bottom: state.showSwitcher
                      ? PreferredSize(
                          preferredSize: const Size.fromHeight(50),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppConstants.paddingMedium),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildTabButton('Users', 0, state),
                                    _buildTabButton('Chat History', 1, state),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            body: IndexedStack(
              index: state.selectedTab,
              children: [
                _buildUsersTab(state),
                _buildChatHistoryTab(state),
              ],
            ),
            floatingActionButton: state.selectedTab == 0
                ? FloatingActionButton(
                    onPressed: _addUser,
                    backgroundColor: AppColors.primaryBlue,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, color: AppColors.textWhite),
                  )
                : null,
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }

  Widget _buildTabButton(String text, int index, HomeLoaded state) {
    final isSelected = state.selectedTab == index;
    return GestureDetector(
      onTap: () => context.read<HomeBloc>().add(ChangeTab(index)),
      child: AnimatedContainer(
        duration: AppConstants.animationDuration,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.scaffoldBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab(HomeLoaded state) {
    if (state.users.isEmpty) {
      return const Center(
        child: Text('No users yet', style: AppTextStyles.emptyState),
      );
    }
    return ListView.builder(
      controller: _usersScrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final user = state.users[index];
        return UserListItem(
          user: user,
          index: index,
          onTap: () => _navigateToChat(
            user,
            state.allMessages[user.id] ?? [],
          ),
        );
      },
    );
  }

  Widget _buildChatHistoryTab(HomeLoaded state) {
    final chatHistory = state.chatHistory;
    if (chatHistory.isEmpty) {
      return const Center(
        child: Text('No chat history yet', style: AppTextStyles.emptyState),
      );
    }
    return ListView.builder(
      controller: _historyScrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: chatHistory.length,
      itemBuilder: (context, index) {
        final chat = chatHistory[index];
        return ChatHistoryItem(
          chat: chat,
          index: index,
          onTap: () => _navigateToChat(
            chat.user,
            state.allMessages[chat.user.id] ?? [],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usersScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }
}

