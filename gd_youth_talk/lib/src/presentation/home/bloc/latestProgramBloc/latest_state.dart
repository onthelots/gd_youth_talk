import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class LatestProgramState {}

class LatestProgramLoadingState extends LatestProgramState {}

class LatestProgramLoadedState extends LatestProgramState {
  final List<ProgramModel> programs;
  LatestProgramLoadedState(this.programs);
}

class LatestProgramErrorState extends LatestProgramState {
  final String message;
  LatestProgramErrorState(this.message);
}

