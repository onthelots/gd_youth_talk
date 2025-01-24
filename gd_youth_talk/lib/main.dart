// package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gd_youth_talk/src/core/app_info/app_info_cubit.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/bloc/reg_email_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/email/reg_email_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/terms/reg_terms_screen.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// firebase
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/category/bloc/category_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme_state.dart';

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

  // env -> API, Secret Key 등을 저장하는 .env 파일 로드
  await dotenv.load();

  // TODO:- App version check
  // 현재 디바이스의 버전 vs Remote config


  Future.delayed(Duration(seconds: 2), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    // theme
    return MultiBlocProvider(
      providers: [
        // Theme
        BlocProvider(
          create: (context) => ThemeBloc()
            ..add(
              ThemeChanged(themeMode: ThemeMode.system), // 기본값으로 시스템 테마 설정
            ),
        ),

        BlocProvider(
          create: (context) => AppInfoCubit()..fetchAppVersion(),
        ),

        // Bottom Navigation
        BlocProvider(
          create: (context) => BottomNavBloc(),
        ),

        // Home Bloc
        BlocProvider(
          create: (context) => HomeBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Search Bloc
        BlocProvider(
          create: (context) => SearchBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Category Bloc
        BlocProvider(
          create: (context) => CategoryBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Calender Bloc
        BlocProvider(
          create: (context) => CalendarBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Calender Bloc
        BlocProvider(
          create: (context) => SelectedCalendarBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // ProgramDetail Bloc
        BlocProvider(
          create: (context) => ProgramDetailBloc(
            repository: locator<ProgramRepository>(),
            usecase: locator<ProgramUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => EmailVerificationBloc(
            usecase: locator<UserUsecase>(),
          ),
        )
      ],
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
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.search:
        final isHomeScreenPushed = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) => SearchScreen(isHomeScreenPushed: isHomeScreenPushed),  // selectedIndex 전달
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
        final docId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(docId: docId),
        );
      case Routes.category:
        final selectedIndex = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(selectedIndex: selectedIndex),
        );
      case Routes.webView:
        final url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WebViewScreen(url: url),
        );
      case Routes.regTerms:
        return MaterialPageRoute(
          builder: (_) => TermsAgreementPage(),
        );
      case Routes.regEmail:
        return MaterialPageRoute(
          builder: (_) => EmailAuthenticationPage(),
        );
      default:
        return null;
    }
  }
}
