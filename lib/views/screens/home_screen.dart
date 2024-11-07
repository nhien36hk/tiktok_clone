import 'package:app_tiktok/constants.dart';
import 'package:app_tiktok/views/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30,), label: 'Hoom'),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 30,), label: 'Profile'),
          BottomNavigationBarItem(icon: CustomIcon(), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message, size: 30,), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30,), label: 'Profile'),
        ],
        onTap: (value) {
          setState(() {
            pageIdx = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        currentIndex: pageIdx,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
      ),
      body: pages[pageIdx],
    );
  }
}
