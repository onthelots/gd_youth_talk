import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/recent_program/recent_program_event.dart';
import 'package:gd_youth_talk/src/presentation/more/bloc/recent_program/recent_program_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/program_model.dart';
import '../../../../domain/usecases/program_usecase.dart';

class RecentProgramBloc extends Bloc<RecentProgramEvent, RecentProgramState> {
  final ProgramUseCase usecase;

  RecentProgramBloc({required ProgramUseCase this.usecase})
      : super(RecentProgramInitial()) {
    on<LoadRecentProgramsEvent>(_onLoadRecentPrograms);
  }

  // 최근 본 프로그램 로드 처리
  Future<void> _onLoadRecentPrograms(
    LoadRecentProgramsEvent event,
      Emitter<RecentProgramState> emit,
      ) async {
    emit(RecentProgramLoading());

    try {
      // SharedPreferences에서 최근 본 프로그램 ID 목록 가져오기
      List<String> recentProgramIds = await _getRecentProgramIds();

      await for (var programs in usecase.getAllPrograms()) {
        final programCopy = List<ProgramModel>.from(programs); // 복제하여 정렬
        List<ProgramModel> recentPrograms = await usecase.getRecentPrograms(programCopy, recentProgramIds);
        emit(RecentProgramLoaded(recentPrograms));
      }

    } catch (e) {
      emit(RecentProgramError("Failed to load recent programs"));
    }
  }

  // SharedPreferences에서 최근 본 프로그램 ID 목록 가져오기
  Future<List<String>> _getRecentProgramIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recent_program_ids') ?? [];
  }
}
