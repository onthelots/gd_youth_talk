import 'package:gd_youth_talk/src/data/models/program_model.dart';

// ProgramState
abstract class RecentProgramState {}

class RecentProgramInitial extends RecentProgramState {}

class RecentProgramLoading extends RecentProgramState {}

class RecentProgramLoaded extends RecentProgramState {
  final List<ProgramModel> programs;
  RecentProgramLoaded(this.programs);
}

class RecentProgramError extends RecentProgramState {
  final String message;
  RecentProgramError(this.message);
}