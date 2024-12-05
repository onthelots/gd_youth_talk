import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/presentation/screens/calendar/calendar_screen.dart';
import 'package:gd_youth_talk/presentation/screens/home/home_screen.dart';
import 'package:gd_youth_talk/presentation/screens/more/more_screen.dart';
import 'package:gd_youth_talk/presentation/screens/search/search_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // index

  // 각각의 Tab 메인화면을 그대로 tab 첫번째 화면으로 활용
  final List<Widget> _tabs = [
    HomeScreen(),
    SearchScreen(),
    CalendarScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // indexedStack으로, 각각의 Tab을 할당할 것
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),

      bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
        currentIndex: _selectedIndex,
        activeColor: AppColors.lightActiveButton,
        inactiveColor: AppColors.lightInactiveButton,
        items: CustomBottomNavigationBar.bottomNavigationBarItem,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      )
          : BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: CustomBottomNavigationBar.bottomNavigationBarItem,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}