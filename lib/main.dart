import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'data/datasource/user_remote_datasource.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/bloc/home/home_bloc.dart';
import 'presentation/navigation/bottom_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        userRepository: UserRepository(
          remoteDatasource: UserRemoteDatasource(),
        ),
      )..add(LoadUsers()),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const BottomNavigationScreen(),
      ),
    );
  }
}
