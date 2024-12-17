import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<ProgramModel> programs;
  HomeLoadedState(this.programs);
}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState(this.message);
}
