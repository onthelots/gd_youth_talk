import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/app/splash_screen.dart';
import 'package:gd_youth_talk/core/theme.dart';
import 'package:gd_youth_talk/presentation/screens/calendar/calendar_screen.dart';
import 'package:gd_youth_talk/presentation/screens/home/home_screen.dart';
import 'package:gd_youth_talk/presentation/screens/landing/landing_screen.dart';
import 'package:gd_youth_talk/presentation/screens/main/main_screen.dart';
import 'package:gd_youth_talk/presentation/screens/more/more_screen.dart';
import 'package:gd_youth_talk/presentation/screens/search/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.landing:
        return MaterialPageRoute(builder: (_) => LandingPage());
      case Routes.main:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case Routes.calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());
      case Routes.more:
        return MaterialPageRoute(builder: (_) => MoreScreen());
      case Routes.category:
        // return MaterialPageRoute(builder: (_) => CategoryScreen());
        return null;

        //TODO: 상세 프로그램 페이지에서는, 데이터를 넘겨받을 것 (settings.arguments)
      case Routes.programDetail:
      // return MaterialPageRoute(builder: (_) => CategoryScreen());
        return null;
      default:
        return null; // 경로가 정의되지 않은 경우 null 반환
    }
  }
}