import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'hits_event.dart';
import 'hits_state.dart';

class HitsProgramBloc extends Bloc<HitsProgramEvent, HitsProgramState> {
  final ProgramUseCase useCase;

  HitsProgramBloc(this.useCase) : super(HitsProgramLoadingState()) {
    on<GetProgramsSortedByHitsEvent>((event, emit) async {
      emit(HitsProgramLoadingState());
      try {
        await for (var programs in useCase.getProgramsSortedByHits()) {
          emit(HitsProgramLoadedState(programs));
        }
      } catch (e) {
        emit(HitsProgramErrorState(e.toString()));
      }
    });
  }
}
