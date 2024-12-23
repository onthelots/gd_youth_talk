import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class SelectedProgramState {}
class SelectedProgramInitial extends SelectedProgramState {}
class SelectedProgramLoadingState extends SelectedProgramState {}

class SelectedProgramLoadedState extends SelectedProgramState {
  final List<ProgramModel> selectedPrograms;
  SelectedProgramLoadedState(this.selectedPrograms);
}

class SelectedProgramErrorState extends SelectedProgramState {
  final String message;
  SelectedProgramErrorState(this.message);
}