// package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gd_youth_talk/src/core/app_info/app_info_cubit.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/reset_password_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_in/sign_in_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/email/reg_email_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/password/reg_password_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/terms/reg_terms_screen.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/sign_up/welcome/reg_welcome_screen.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/recent_program/recent_program_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/recent_program/recent_program_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_state.dart';
import 'package:gd_youth_talk/src/presentation/more/mypage_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/oss_license_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/setting_menu_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/theme_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/user/user_screen.dart';
import 'package:gd_youth_talk/src/presentation/qr_code/qr_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

// firebase
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/category/bloc/category_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/theme/theme_bloc.dart';

// constant
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/screens.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/core/theme.dart';

// usecase
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

        // version
        BlocProvider(
          create: (context) => AppInfoCubit()..fetchAppVersion(),
        ),

        // Recent See Programs
        BlocProvider(
          create: (context) => RecentProgramBloc(
            usecase: locator<ProgramUseCase>(),
          )..add(LoadRecentProgramsEvent())
        ),

        // Bottom Navigation
        BlocProvider(
          create: (context) => BottomNavBloc(),
        ),

        // Home Bloc
        BlocProvider(
          create: (context) => HomeBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Search Bloc
        BlocProvider(
          create: (context) => SearchBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Category Bloc
        BlocProvider(
          create: (context) => CategoryBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Calender Bloc
        BlocProvider(
          create: (context) => CalendarBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // Calender Bloc
        BlocProvider(
          create: (context) => SelectedCalendarBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // ProgramDetail Bloc
        BlocProvider(
          create: (context) => ProgramDetailBloc(
            usecase: locator<ProgramUseCase>(),
          ),
        ),

        // User Bloc
        BlocProvider(
          create: (context) => UserBloc(
            usecase: locator<UserUsecase>(),
          )..add(AppStarted()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final themeMode =
                  (state is ThemeInitial) ? state.themeMode : ThemeMode.system;
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
      case Routes.signIn:
        return MaterialPageRoute(
          builder: (_) => SignInScreen(),
        );
      case Routes.resetPw:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(),
        );
      case Routes.regTerms:
        return MaterialPageRoute(
          builder: (_) => TermsAgreementPage(),
        );
      case Routes.regEmail:
        return MaterialPageRoute(
          builder: (_) => EmailAuthenticationPage(),
        );
      case Routes.regPassword:
        return MaterialPageRoute(
          builder: (_) => PasswordAuthenticationPage(),
        );
      case Routes.regWelcome:
        return MaterialPageRoute(
          builder: (_) => WelcomeAuthenticationPage(),
        );
      case Routes.myPage:
        return MaterialPageRoute(
          builder: (_) => MyPageScreen(),
        );
      case Routes.user:
        return MaterialPageRoute(
          builder: (_) => UserScreen(),
        );
      case Routes.qr:
        final documentId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => QRCodeScreen(documentId: documentId),
        );
      case Routes.setting:
        return MaterialPageRoute(
          builder: (_) => SettingMenuScreen(),
        );
      case Routes.themeSetting:
        return MaterialPageRoute(
          builder: (_) => ThemeSettingsScreen(),
        );
      case Routes.openSource:
        return MaterialPageRoute(
          builder: (_) => OssLicensesPage(),
        );
      default:
        return null;
    }
  }
}
