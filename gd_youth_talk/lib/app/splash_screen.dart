import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Stream<List<ProgramModel>> _programStream;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // 딜레이

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
        child: CircularProgressIndicator(),
      ),
    );
  }
}