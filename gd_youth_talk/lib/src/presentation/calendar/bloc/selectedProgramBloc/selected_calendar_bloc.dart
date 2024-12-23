import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'selected_calendar_event.dart';
import 'selected_calendar_state.dart';

class SelectedCalendarBloc
    extends Bloc<SelectedProgramEvent, SelectedProgramState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  SelectedCalendarBloc({
    required this.repository,
    required this.usecase,
  }) : super(SelectedProgramInitial()) {
    on<GetProgramsByDate>((event, emit) async {
      emit(SelectedProgramLoadingState());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(SelectedProgramLoadedState(
              usecase.filterByDate(programs, event.date)));
        }
      } catch (e) {
        emit(SelectedProgramErrorState("Failed to load programs"));
      }
    });
  }
}
