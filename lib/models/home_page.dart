import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:haber/compenents/my_bottomnavigation.dart';
import 'package:haber/screens/message_screen.dart';
import 'package:haber/screens/news_screen.dart';
import 'package:haber/screens/profile_screen.dart';
import 'package:haber/screens/saved_screen.dart';
import 'package:haber/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0);
  final controller = NotchBottomBarController(index: 0);

  int maxCount = 4;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPages = [
    const NewsScreen(),
    SavedScreen(AuthService().firebaseAuth.currentUser!.uid,false),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: MyNavigation(
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        controller: controller,
      ),
    );
  }
}