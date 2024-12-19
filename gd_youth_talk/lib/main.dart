// package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/ctaProgramBloc/cta_bloc.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/hitsProgramBloc/hits_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_state.dart';
import 'package:intl/date_symbol_data_local.dart';

// firebase
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/home/bloc/latestProgramBloc/latest_bloc.dart';
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

  // Initialize Locale
  await initializeDateFormatting('ko_KR', null);

  // env
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    // theme
    return BlocProvider(
      create: (context) => ThemeBloc()..add(
        ThemeChanged(themeMode: ThemeMode.system), // 기본값으로 시스템 테마 설정
      ),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final themeMode = (state is ThemeInitial) ? state.themeMode : ThemeMode.system;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                initialRoute: Routes.main,
                onGenerateRoute: _router.onGenerateRoute,
              );
            },
          );
        },
      ),
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
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BottomNavBloc()),  // BottomNavBloc 주입
                BlocProvider(create: (_) => LatestProgramBloc(locator<ProgramUseCase>())),  // LatestProgramBloc 주입
                BlocProvider(create: (_) => CTAProgramBloc(locator<ProgramUseCase>())),  // CTAProgramBloc 주입
                BlocProvider(create: (_) => HitsProgramBloc(locator<ProgramUseCase>())),  // CTAProgramBloc 주입
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
        final isHomeScreenPushed = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => SearchBloc(locator<ProgramUseCase>())),  // CategoryBloc 주입
              ],
              child: SearchScreen(isHomeScreenPushed: isHomeScreenPushed),  // selectedIndex 전달
            );
          },
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
          builder: (_) => ThemeSettingsScreen(),
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
