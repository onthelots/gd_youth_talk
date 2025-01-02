import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
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
          final programCopy = List<ProgramModel>.from(programs); // 복제하여 데이터 보호
          emit(CalendarLoadedState(programs: usecase.groupByDate(programCopy)));
        }
      } catch (e) {
        emit(CalendarErrorState("Failed to load programs"));
      }
    });
  }
}
