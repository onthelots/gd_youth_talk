import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gd_youth_talk/src/core/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Splash 애니메이션 이후, isFirstLaunch에 따른 첫 화면 분기처리 실시
  Future<void> _navigateToNextScreen() async {
    // 3초 동안 로고를 보여준 후, 다음 화면으로 이동
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacementNamed(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200, height: 200,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
