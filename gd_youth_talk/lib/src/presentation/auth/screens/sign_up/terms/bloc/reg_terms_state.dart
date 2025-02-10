import 'package:equatable/equatable.dart';

class TermsState extends Equatable {
  final bool agreeAll;
  final bool ageConfirmed;
  final bool termsOfService;
  final bool privacyPolicy;

  const TermsState({
    this.agreeAll = false,
    this.ageConfirmed = false,
    this.termsOfService = false,
    this.privacyPolicy = false,
  });

  @override
  List<Object?> get props => [agreeAll, ageConfirmed, termsOfService, privacyPolicy];

  TermsState copyWith({
    bool? agreeAll,
    bool? ageConfirmed,
    bool? termsOfService,
    bool? privacyPolicy,
  }) {
    return TermsState(
      agreeAll: agreeAll ?? this.agreeAll,
      ageConfirmed: ageConfirmed ?? this.ageConfirmed,
      termsOfService: termsOfService ?? this.termsOfService,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
    );
  }
}