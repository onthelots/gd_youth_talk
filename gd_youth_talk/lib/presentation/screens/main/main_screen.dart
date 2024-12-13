import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/presentation/bloc/bottom_nav_bloc.dart';
import 'package:gd_youth_talk/presentation/screens/calendar/calendar_screen.dart';
import 'package:gd_youth_talk/presentation/screens/home/home_screen.dart';
import 'package:gd_youth_talk/presentation/screens/more/more_screen.dart';
import 'package:gd_youth_talk/presentation/screens/search/search_screen.dart';

class MainScreen extends StatelessWidget {

  final List<Widget> _tabs = [
    HomeScreen(),
    // SearchScreen(),
    // CalendarScreen(),
    // MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavBloc>(
      create: (context) => BottomNavBloc(), // bloc 주입
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          final currentIndex = (state as TabState).index; // 기본값 0
          return Scaffold(
            // indexedStack으로, 각각의 Tab을 할당할 것
            body: IndexedStack(
              index: currentIndex,
              children: _tabs,
            ),

            bottomNavigationBar: Platform.isIOS
                ? CupertinoTabBar(
              currentIndex: currentIndex,
              activeColor: AppColors.lightActiveButton,
              inactiveColor: AppColors.lightInactiveButton,
              items: CustomBottomNavigationBar.bottomNavigationBarItem,
              onTap: (index) {
                context.read<BottomNavBloc>().add(TabSelected(index)); // event 전달
              },
            )
                : BottomNavigationBar(
              currentIndex: currentIndex,
              items: CustomBottomNavigationBar.bottomNavigationBarItem,
              onTap: (index) {
                context.read<BottomNavBloc>().add(TabSelected(index)); // event 전달
              },
            ),
          );
        },
      ),
    );
  }
}