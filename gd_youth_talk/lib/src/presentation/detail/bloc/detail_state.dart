import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class ProgramDetailState {}

class ProgramDetailInitial extends ProgramDetailState {}

class ProgramDetailLoading extends ProgramDetailState {}

class ProgramDetailLoaded extends ProgramDetailState {
  final ProgramModel program;
  ProgramDetailLoaded({required this.program});
}

class ProgramDetailError extends ProgramDetailState {
  final String message;
  ProgramDetailError(this.message);
}