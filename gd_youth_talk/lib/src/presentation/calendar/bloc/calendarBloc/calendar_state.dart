import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class CalendarState {}

class CalendarLoadingState extends CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoadedState extends CalendarState {
  final List<ProgramModel> programs;
  CalendarLoadedState({required this.programs});
}

class CalendarErrorState extends CalendarState {
  final String message;
  CalendarErrorState(this.message);
}