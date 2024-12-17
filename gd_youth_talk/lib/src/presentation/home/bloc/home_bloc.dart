import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProgramUseCase useCase;

  HomeBloc(this.useCase) : super(HomeLoadingState()) {
    on<GetLatestProgramsEvent>((event, emit) async {
      emit(HomeLoadingState());
      try {
        await for (var programs in useCase.getLatestPrograms()) {
          emit(HomeLoadedState(programs));
        }
      } catch (e) {
        emit(HomeErrorState(e.toString()));
      }
    });
  }
}
