import 'package:codogram_app_frontend/view/feed_view.dart';
import 'package:codogram_app_frontend/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex=2;

  // List of screens that correspond to the navigation items
  static final List<Widget> _screens = [
    Container(
      color: Colors.green,
    ), // Search Page
    HomeScreen(), // Cart Page
    FeedView(), // Home Page (center, default)
    Container(color: Colors.white,), // Flash/another page
    Container(color: Colors.red,), // Profile Page (last item)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Update selected index when a navigation item is tapped
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[
      _selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Background color of the bar
        color: Colors.brown.shade900, // Bar color
        buttonBackgroundColor: Colors.orange.shade600, // Button color
        height: 60, // Height of the bar
        index: _selectedIndex,

        // Navigation items (icons)
        items: const <Widget>[
          Icon(Icons.search,
              size: 30, color: Colors.white), // Search icon (index 0)
          Icon(Icons.shopping_cart,
              size: 30, color: Colors.white), // Cart icon (index 1)
          Icon(Icons.home,
              size: 30, color: Colors.white), // Home icon (index 2, center)
          Icon(Icons.flash_on,
              size: 30, color: Colors.white), // Flash/other icon (index 3)
          Icon(Icons.person,
              size: 30, color: Colors.white), // Profile icon (index 4, last)
        ],

        // Handle the tap event
        onTap: (index) {
          if (index < _screens.length) {
            _onItemTapped(
                index); // Update the selected index when an item is tapped
          }
        },
      ),

    );
  }
}
