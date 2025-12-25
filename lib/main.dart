import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'screens/main_screen.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const MiniChatApp());
}

class MiniChatApp extends StatelessWidget {
  const MiniChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => ChatBloc()),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

