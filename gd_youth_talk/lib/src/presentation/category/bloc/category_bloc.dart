import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProgramUseCase useCase;

  CategoryBloc(this.useCase) : super(CategoryLoadingState()) {
    on<GetProgramsByCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      try {
        await for (var programs in useCase.getProgramsByCategory(event.category)) {
          emit(CategoryLoadedState(programs));
        }
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });
  }
}
