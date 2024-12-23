import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchProgramEvent, SearchState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  SearchBloc({
    required this.repository,
    required this.usecase,
  }) : super(SearchLoadingState()) {
    on<SearchQueryProgramsEvent>((event, emit) async {
      emit(SearchLoadingState());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(SearchLoadedState(
              searchPrograms: usecase.searchPrograms(programs, event.query)));
        }
      } catch (e) {
        emit(SearchErrorState(e.toString()));
      }
    });
  }
}
