import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ProgramUseCase useCase;

  CalendarBloc(this.useCase) : super(CalendarLoadingState()) {
    on<GetProgramsGroupedByDate>((event, emit) async {
      emit(CalendarLoadingState());
      try {
        await for (var programs in useCase.getProgramsGroupedByDate()) {
          emit(CalendarLoadedState(programs));
        }
      } catch (e) {
        emit(CalendarErrorState(e.toString()));
      }
    });
  }
}