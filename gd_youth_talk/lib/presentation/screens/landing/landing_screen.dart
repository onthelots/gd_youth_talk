import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/routes.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Landing Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.main);
          },
          child: Text('Go to Main Screen'),
        ),
      ),
    );
  }
}