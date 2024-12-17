import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'selected_calendar_event.dart';
import 'selected_calendar_state.dart';

class SelectedCalendarBloc extends Bloc<SelectedProgramEvent, SelectedProgramState> {
  final ProgramUseCase useCase;

  SelectedCalendarBloc(this.useCase) : super(SelectedProgramLoadingState()) {
    on<GetProgramsByDate>((event, emit) async {
      emit(SelectedProgramLoadingState());
      try {
        await for (var programs in useCase.getProgramsByDate(event.date)) {
          emit(SelectedProgramLoadedState(programs));
        }
      } catch (e) {
        emit(SelectedProgramErrorState(e.toString()));
      }
    });
  }
}