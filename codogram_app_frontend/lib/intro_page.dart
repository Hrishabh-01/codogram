import 'dart:ui';
import 'package:codogram_app_frontend/res/color.dart';
import 'package:codogram_app_frontend/view/feed_view.dart';
import 'package:codogram_app_frontend/view/home_screen.dart';
import 'package:codogram_app_frontend/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex = 2;

  static final List<Widget> _screens = [
    Container(color: Colors.green), // Search Page
    HomeScreen(), // Chat Page
    FeedView(), // Home Page
    Container(color: Colors.white), // Flash Page
    ProfileView()// Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Optional: match FeedView background
      body: Stack(
        children: [
          _screens[_selectedIndex], // Your current screen

          // 🎯 Floating nav bar placed with Positioned
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 1,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: CurvedNavigationBar(
                    backgroundColor: Colors.transparent,
                    color: AppColors.navBarColor.withOpacity(0.85),
                    buttonBackgroundColor: AppColors.navButtonColor,
                    height: 60,
                    index: _selectedIndex,
                    animationDuration: Duration(milliseconds: 300),
                    items: const <Widget>[
                      Icon(Icons.search, size: 25, color: Colors.white),
                      Icon(Icons.chat_bubble, size: 25, color: Colors.white),
                      Icon(Icons.home, size: 25, color: Colors.white),
                      Icon(Icons.flash_on, size: 25, color: Colors.white),
                      Icon(Icons.person, size: 25, color: Colors.white),
                    ],
                    onTap: (index) {
                      if (index < _screens.length) {
                        _onItemTapped(index);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
