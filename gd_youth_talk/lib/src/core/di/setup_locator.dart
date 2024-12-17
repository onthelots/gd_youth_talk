import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/data/sources/programs_datasource.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';

final locator = GetIt.instance;

void setupLocator() {
  // FirebaseFirestore 등록
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // DataSource 등록
  locator.registerLazySingleton<ProgramDataSource>(
          () => ProgramDataSource(locator<FirebaseFirestore>()));

  // Repository 등록
  locator.registerLazySingleton<ProgramRepository>(
          () => ProgramRepository(locator<ProgramDataSource>()));

  // UseCase 등록
  locator.registerLazySingleton<ProgramUseCase>(
          () => ProgramUseCase(locator<ProgramRepository>()));
}
