import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ProgramUseCase usecase;

  CalendarBloc({
    required this.usecase,
  }) : super(CalendarInitial()) {

    on<GetAllPrograms>((event, emit) async {
      emit(CalendarLoadingState());
      try {
        await for (var programs in usecase.getAllPrograms()) {
          emit(CalendarLoadedState(programs: programs));
        }
      } catch (e) {
        emit(CalendarErrorState("Failed to load programs"));
      }
    });
  }
}
