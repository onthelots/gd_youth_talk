import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'cta_event.dart';
import 'cta_state.dart';

class CTAProgramBloc extends Bloc<CTAProgramEvent, CTAProgramState> {
  final ProgramUseCase useCase;

  CTAProgramBloc(this.useCase) : super(CTAProgramLoadingState()) {
    on<GetCallToActionProgramEvent>((event, emit) async {
      emit(CTAProgramLoadingState());
      try {
        await for (var programs in useCase.getCTAPrograms()) {
          emit(CTAProgramLoadedState(programs));
        }
      } catch (e) {
        emit(CTAProgramErrorState(e.toString()));
      }
    });
  }
}
