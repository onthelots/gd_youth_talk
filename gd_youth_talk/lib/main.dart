// package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// firebase
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/home/bloc/home_bloc.dart';
import 'package:gd_youth_talk/src/presentation/category/bloc/category_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc.dart';

// constant
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/screens.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/core/theme.dart';

// model, usecase
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';

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

  // Initialize Dependency Injection
  setupLocator();

  // env
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case Routes.landing:
        return MaterialPageRoute(
          builder: (_) => LandingPage(),
        );
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BottomNavBloc()),  // BottomNavBloc 주입
                BlocProvider(create: (_) => HomeBloc(locator<ProgramUseCase>())),  // HomeBloc 주입
                BlocProvider(create: (_) => SearchBloc(locator<ProgramUseCase>())),  // HomeBloc 주입
                BlocProvider(create: (_) => CalendarBloc(locator<ProgramUseCase>())),  // HomeBloc 주입
                BlocProvider(create: (_) => SelectedCalendarBloc(locator<ProgramUseCase>())),  // HomeBloc 주입
              ],
              child: MainScreen(),
            );
          },
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(),
        );
      case Routes.calendar:
        return MaterialPageRoute(
          builder: (_) => CalendarScreen(),
        );
      case Routes.more:
        return MaterialPageRoute(
          builder: (_) => MoreScreen(),
        );
      case Routes.setting:
        return MaterialPageRoute(
          builder: (_) => ThemeScreen(),
        );
      case Routes.programDetail:
        final program = settings.arguments as ProgramModel;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(program: program),
        );
      case Routes.category:
        final selectedIndex = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => CategoryBloc(locator<ProgramUseCase>())),  // CategoryBloc 주입
              ],
              child: CategoryScreen(selectedIndex: selectedIndex),  // selectedIndex 전달
            );
          },
        );
      case Routes.webView:
        final url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WebViewScreen(url: url),
        );
      default:
        return null;
    }
  }
}
