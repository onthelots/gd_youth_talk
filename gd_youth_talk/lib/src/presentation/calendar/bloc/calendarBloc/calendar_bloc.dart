import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  CalendarBloc({
    required this.repository,
    required this.usecase,
  }) : super(CalendarInitial()) {
    on<GetProgramsGroupedByDate>((event, emit) async {
      emit(CalendarLoadingState());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(CalendarLoadedState(programs: usecase.groupByDate(programs)));
        }
      } catch (e) {
        emit(CalendarErrorState("Failed to load programs"));
      }
    });
  }
}
