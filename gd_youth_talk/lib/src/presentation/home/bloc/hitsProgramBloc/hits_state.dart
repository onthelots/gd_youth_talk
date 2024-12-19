import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class HitsProgramState {}

class HitsProgramLoadingState extends HitsProgramState {}

class HitsProgramLoadedState extends HitsProgramState {
  final List<ProgramModel> programs;
  HitsProgramLoadedState(this.programs);
}

class HitsProgramErrorState extends HitsProgramState {
  final String message;
  HitsProgramErrorState(this.message);
}
