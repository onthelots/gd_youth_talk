import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProgramRepository repository;
  final ProgramUseCase usecase;

  CategoryBloc({
    required this.repository,
    required this.usecase,
  }) : super(CategoryInitial()) {
    on<LoadCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await for (var programs in repository.getPrograms()) {
          emit(
            CategoryLoaded(
                categoryPrograms:
                    usecase.filterByCategory(programs, event.category),
                category: event.category),
          );
        }
      } catch (e) {
        emit(CategoryError("Failed to load programs"));
      }
    });
  }
}
