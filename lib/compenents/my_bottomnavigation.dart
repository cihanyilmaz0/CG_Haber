import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class MyNavigation extends StatelessWidget {
  final NotchBottomBarController controller;
  final Function(int index) onTap;


  MyNavigation({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: controller,
      durationInMilliSeconds: 300,
      onTap: onTap,
      color: Colors.black87,
      notchColor: Colors.black,
      bottomBarItems: const[
        BottomBarItem(
          inActiveItem: Icon(
            Icons.home_outlined,
            color: Colors.grey,
          ),
          activeItem: Icon(
            Icons.home_filled,
            color: Colors.white,
          ),
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.bookmark_outline,
            color: Colors.grey,
          ),
          activeItem: Icon(
            Icons.bookmark,
            color: Colors.white,
          ),
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.chat_bubble_outline_outlined,
            color: Colors.grey,
          ),
          activeItem: Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
          activeItem: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
