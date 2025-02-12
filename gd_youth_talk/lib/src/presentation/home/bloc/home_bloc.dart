import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_event.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProgramUseCase usecase;

  HomeBloc({
    required this.usecase,
  }) : super(HomeInitial()) {
    on<LoadPrograms>((event, emit) async {
      emit(HomeLoading());
      try {
        await for (var programs in usecase.getAllPrograms()) {
          final programCopy = List<ProgramModel>.from(programs); // 복제하여 정렬
          emit(HomeLoaded(
            latestPrograms: usecase.getLatestPrograms(programCopy),
            popularPrograms: usecase.sortByHits(programCopy),
            upcomingPrograms: usecase.getUpcomingPrograms(programCopy),
          ));
        }
      } catch (e) {
        emit(HomeError("Failed to load programs"));
      }
    });
  }
}