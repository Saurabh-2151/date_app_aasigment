import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/bloc/home/home_bloc.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> _users = [];
  int _currentIndex = 0;

  List<UserModel> _filterUsers(List<UserModel> all) {
    final females = all.where((u) => u.gender == 'female').toList();
    return females.isNotEmpty ? females : all;
  }

  void _onSwipe() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded) {
          setState(() {
            _users = _filterUsers(state.users);
            _currentIndex = 0;
          });
        }
      },
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))),
          );
        }
        if (state is HomeError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Color(0xFFE91E63)),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HomeBloc>().add(RefreshUsers()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (_users.isEmpty) return const Scaffold(body: SizedBox.shrink());

        return HomePage(
          users: _users,
          currentIndex: _currentIndex,
          onSwipe: _onSwipe,
          onRefresh: () async => context.read<HomeBloc>().add(RefreshUsers()),
        );
      },
    );
  }
}
