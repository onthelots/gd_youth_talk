import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/screens.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc/bottom_nav_event.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc/bottom_nav_state.dart';
import 'package:gd_youth_talk/src/presentation/more/mypage_screen.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_bloc.dart';

class MainScreen extends StatelessWidget {

  final List<Widget> _tabs = [
    HomeScreen(),
    SearchScreen(isHomeScreenPushed: false),
    CalendarScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, TabState>(
      builder: (context, state) {
        final currentIndex = (state as TabState).index; // 기본값 0
        return Scaffold(
          // IndexedStack을 사용하여 탭 전환
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
              context.read<BottomNavBloc>().add(TabSelected(index)); // 이벤트 전달
            },
          )
              : BottomNavigationBar(
            currentIndex: currentIndex,
            items: CustomBottomNavigationBar.bottomNavigationBarItem,
            onTap: (index) {
              context.read<BottomNavBloc>().add(TabSelected(index)); // 이벤트 전달
            },
          ),
        );
      },
    );
  }
}
