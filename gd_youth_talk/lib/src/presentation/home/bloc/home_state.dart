import 'package:gd_youth_talk/src/data/models/program_model.dart';

class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<ProgramModel> latestPrograms;
  final List<ProgramModel> popularPrograms;
  final List<ProgramModel> upcomingPrograms;

  HomeLoaded({
    required this.latestPrograms,
    required this.popularPrograms,
    required this.upcomingPrograms,
  });
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}