import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';
import 'package:gd_youth_talk/domain/usecases/program_usecase.dart';

/// Event 정의
abstract class ProgramEvent {}

// Event 1. 최근 날짜 기준
class GetLatestProgramsEvent extends ProgramEvent {}

// Event 2. 카테고리 기준
class GetProgramsByCategoryEvent extends ProgramEvent {
  final String category;

  GetProgramsByCategoryEvent(this.category);
}

// Event 3. 검색 기준
class SearchProgramsEvent extends ProgramEvent {
  final String query;

  SearchProgramsEvent(this.query);
}

// Event 4. 날짜 기준
class GetProgramsByDateEvent extends ProgramEvent {
  final DateTime date;

  GetProgramsByDateEvent(this.date);
}

// Event 5. 카테고리 별 프로그램 (Map 형식)
class LoadProgramsByCategories extends ProgramEvent {}

/// State 정의
abstract class ProgramState {}

// State 1. Loading
class ProgramLoadingState extends ProgramState {}

// State 2. Loaded
class ProgramLoadedState extends ProgramState {
  late List<ProgramModel> latestPrograms;
  late Map<String, List<ProgramModel>> categorizedPrograms;

  ProgramLoadedState(this.latestPrograms, this.categorizedPrograms);
}

// State 3. Error
class ProgramErrorState extends ProgramState {
  final String message;

  ProgramErrorState(this.message);
}

/// Bloc 클래스
class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {

  // usecase 할당
  final ProgramUseCase useCase;

  ProgramBloc(this.useCase) : super(ProgramLoadingState()) {

    // GetLatestProgramsEvent 처리
    on<GetLatestProgramsEvent>((event, emit) async {
      emit(ProgramLoadingState()); // 로딩중
      try {
        final latestPrograms = await useCase.getLatestPrograms().first;
        if (latestPrograms.isEmpty) {
          emit(ProgramErrorState('데이터가 없습니다.'));
        } else {
          emit(ProgramLoadedState(latestPrograms, {}));
        }
      } catch (e) {
        emit(ProgramErrorState(e.toString())); // 에러
        print(e);
      }
    });

    // GetProgramsByCategoryEvent 처리
    // on<LoadProgramsByCategories>((event, emit) async {
    //   emit(ProgramLoadingState()); // 로딩중
    //   try {
    //     final categorizedPrograms = await useCase.getProgramsByCategories().first;
    //     emit(ProgramLoadedState(latestPrograms: [], categorizedPrograms: categorizedPrograms)); // 로드 완료
    //   } catch (e) {
    //     emit(ProgramErrorState(e.toString())); // 에러
    //     print(e);
    //   }
    // });
    // //
    // GetProgramsByCategoryEvent 처리
    // on<GetProgramsByCategoryEvent>((event, emit) async {
    //   emit(ProgramLoadingState()); // 로딩중
    //   try {
    //     final categoryPrograms = await useCase.getProgramsByCategory(event.category).first;
    //     final currentState = state as ProgramLoadedState;
    //     emit(ProgramLoadedState(categoryPrograms: categoryPrograms)); // 로드 완료
    //   } catch (e) {
    //     emit(ProgramErrorState(e.toString())); // 에러
    //   }
    // });
    //
    // SearchProgramsEvent 처리
    // on<SearchProgramsEvent>((event, emit) async {
    //   emit(ProgramLoadingState()); // 로딩중
    //   try {
    //     final programs = await useCase.searchPrograms(event.query).first;
    //     emit(ProgramLoadedState(programs)); // 로드 완료
    //   } catch (e) {
    //     emit(ProgramErrorState(e.toString())); // 에러
    //   }
    // });
    //
    // GetProgramsByDateEvent 처리
    // on<GetProgramsByDateEvent>((event, emit) async {
    //   emit(ProgramLoadingState());
    //   try {
    //     final programs = await useCase.getProgramsByDate(event.date).first;
    //     emit(ProgramLoadedState(programs));
    //   } catch (e) {
    //     emit(ProgramErrorState(e.toString()));
    //   }
    // });
  }
}
