import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../screens/home/home_screen.dart';
import '../screens/date_now/date_now_screen.dart';
import '../screens/admirers/admirers_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/events/events_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    DateNowScreen(),
    AdmirersScreen(),
    ChatScreen(),
    EventsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 24),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_fill_outlined, size: 24),
              activeIcon: Icon(Icons.play_circle_fill_outlined, size: 24),
              label: AppStrings.dateNow,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined, size: 24),
              activeIcon: Icon(Icons.favorite_outline_rounded, size: 24),
              label: AppStrings.admirers,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded, size: 24),
              activeIcon: Icon(Icons.chat_bubble_rounded, size: 24),
              label: AppStrings.chat,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_outlined, size: 24),
              activeIcon: Icon(Icons.event_rounded, size: 24),
              label: AppStrings.events,
            ),
          ],
        ),
      ),
    );
  }
}
