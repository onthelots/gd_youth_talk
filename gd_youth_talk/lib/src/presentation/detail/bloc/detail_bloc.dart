import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_event.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_state.dart';

class ProgramDetailBloc extends Bloc<ProgramDetailEvent, ProgramDetailState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  ProgramDetailBloc({
    required this.repository,
    required this.usecase,
  }) : super(ProgramDetailInitial()) {
    on<LoadProgramDetailEvent>((event, emit) async {
      emit(ProgramDetailLoading());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(
            ProgramDetailLoaded(program: usecase.getProgramDetail(programs, event.docId))
          );
        }

      } catch (e) {
        emit(ProgramDetailError("Failed to load programs"));
      }
    });
  }
}
