import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';

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

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      prefs.setBool('isFirstLaunch', false);
      Navigator.of(context).pushReplacementNamed(Routes.landing);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: SizedBox(
              width: 100, height: 100, child: Icon(Icons.add)),
        ),
      ),
    );
  }
}