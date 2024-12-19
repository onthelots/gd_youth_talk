import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'latest_event.dart';
import 'latest_state.dart';

class LatestProgramBloc extends Bloc<LatestProgramEvent, LatestProgramState> {
  final ProgramUseCase useCase;

  LatestProgramBloc(this.useCase) : super(LatestProgramLoadingState()) {
    on<GetLatestProgramEvent>((event, emit) async {
      emit(LatestProgramLoadingState());
      try {
        await for (var programs in useCase.getLatestPrograms()) {
          emit(LatestProgramLoadedState(programs));
        }
      } catch (e) {
        emit(LatestProgramErrorState(e.toString()));
      }
    });
  }
}
