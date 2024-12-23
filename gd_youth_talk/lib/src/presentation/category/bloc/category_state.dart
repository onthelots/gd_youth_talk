import 'package:gd_youth_talk/src/data/models/program_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<ProgramModel> categoryPrograms;
  final String category;
  CategoryLoaded({required this.category, required this.categoryPrograms});
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}