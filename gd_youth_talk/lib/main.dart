import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/app/splash_screen.dart';
import 'package:gd_youth_talk/core/theme.dart';
import 'package:gd_youth_talk/presentation/screens/more/theme_screen.dart';
import 'app/dummy_data.dart';
import 'package:gd_youth_talk/presentation/screens/calendar/calendar_screen.dart';
import 'package:gd_youth_talk/presentation/screens/detail/detail_screen.dart';
import 'package:gd_youth_talk/presentation/screens/home/category_screen.dart';
import 'package:gd_youth_talk/presentation/screens/home/home_screen.dart';
import 'package:gd_youth_talk/presentation/screens/landing/landing_screen.dart';
import 'package:gd_youth_talk/presentation/screens/main/main_screen.dart';
import 'package:gd_youth_talk/presentation/screens/search/search_screen.dart';
import 'package:gd_youth_talk/presentation/screens/more/more_screen.dart';
import 'package:gd_youth_talk/presentation/screens/web/webview_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      case Routes.setting:
        return MaterialPageRoute(builder: (_) => ThemeScreen());
      case Routes.programDetail:
        return MaterialPageRoute(builder: (_) => DetailScreen(program: settings.arguments as Program));
      case Routes.category:
        final pageIndex = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => CategoryScreen(selectedIndex: pageIndex));
      case Routes.webView:
        final url = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WebViewScreen(url: url));
      default:
        return null;
    }
  }
}