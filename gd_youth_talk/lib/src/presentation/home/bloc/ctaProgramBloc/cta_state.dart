import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class CTAProgramState {}

class CTAProgramLoadingState extends CTAProgramState {}

class CTAProgramLoadedState extends CTAProgramState {
  final List<ProgramModel> programs;
  CTAProgramLoadedState(this.programs);
}

class CTAProgramErrorState extends CTAProgramState {
  final String message;
  CTAProgramErrorState(this.message);
}
