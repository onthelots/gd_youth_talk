import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';

class DetailScreen extends StatelessWidget {
  final ProgramModel program;

  DetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text('자세히보기'),
      ),
      body: Center(
        child: Text(
          'Program title : ${this.program.title}'
        ),
      ),
    );
  }
}
