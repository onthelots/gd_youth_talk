import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<ProgramModel> searchPrograms;
  SearchLoadedState({required this.searchPrograms});
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState(this.message);
}