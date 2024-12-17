import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<ProgramModel> programs;
  SearchLoadedState(this.programs);
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState(this.message);
}
