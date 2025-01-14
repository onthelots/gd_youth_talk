import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/terms/bloc/reg_terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit() : super(const TermsState());

  // 전체 동의 checkbox > All menu toggle
  void toggleAgreeAll(bool value) {
    emit(state.copyWith(
      agreeAll: value,
      ageConfirmed: value,
      termsOfService: value,
      privacyPolicy: value,
    ));
  }

  // 개별 checkbox toggle
  void updateIndividual(String type, bool value) {

    // 개별 checkbox 상태값 변경
    // 각각의 상태값을 변경해야 하므로, 'type'을 일종의 flag로 활용
    final updatedState = state.copyWith(
      ageConfirmed: type == 'age' ? value : state.ageConfirmed,
      termsOfService: type == 'terms' ? value : state.termsOfService,
      privacyPolicy: type == 'privacy' ? value : state.privacyPolicy,
    );

    // 개별 checkbox 상태값에 따라 지속적으로 변경 (개별 checkbox가 모두 true일 경우, true로 변경)
    // 이는 updateIndividual 실행 시, 하단 emit에 따라 TermsState 값 변경
    final allAgreed = updatedState.ageConfirmed &&
        updatedState.termsOfService &&
        updatedState.privacyPolicy;

    // allAgreed 상태에 따라 지속적으로 emit을 실시 > 전체동의 checkbox 상태를 변경하기 위해
    emit(updatedState.copyWith(agreeAll: allAgreed));
  }
}