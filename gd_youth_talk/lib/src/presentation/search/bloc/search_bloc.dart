import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchProgramEvent, SearchState> {
  final ProgramUseCase useCase;

  SearchBloc(this.useCase) : super(SearchLoadingState()) {
    on<SearchQueryProgramsEvent>((event, emit) async {
      emit(SearchLoadingState());
      try {
        await for (var programs in useCase.searchPrograms(event.query)) {
          emit(SearchLoadedState(programs));
        }
      } catch (e) {
        emit(SearchErrorState(e.toString()));
      }
    });
  }
}
