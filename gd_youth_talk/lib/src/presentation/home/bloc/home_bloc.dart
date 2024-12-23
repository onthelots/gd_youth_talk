import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_event.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  HomeBloc({
    required this.repository,
    required this.usecase,
  }) : super(HomeInitial()) {
    on<LoadPrograms>((event, emit) async {
      emit(HomeLoading());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(HomeLoaded(
            latestPrograms: usecase.getLatestPrograms(programs),
            popularPrograms: usecase.sortByHits(programs),
            upcomingPrograms: usecase.getUpcomingPrograms(programs),
          ));
        }
      } catch (e) {
        emit(HomeError("Failed to load programs"));
      }
    });
  }
}