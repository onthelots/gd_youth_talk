import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<ProgramModel> programs;
  CategoryLoadedState(this.programs);
}

class CategoryErrorState extends CategoryState {
  final String message;
  CategoryErrorState(this.message);
}
