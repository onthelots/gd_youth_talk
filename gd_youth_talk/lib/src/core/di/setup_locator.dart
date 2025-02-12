import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gd_youth_talk/src/data/sources/user_datasource.dart';
import 'package:gd_youth_talk/src/domain/repositories/user_repository.dart';
import 'package:gd_youth_talk/src/domain/usecases/user_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:gd_youth_talk/src/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/src/data/sources/programs_datasource.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Program DataSource 등록
  locator.registerLazySingleton<ProgramDataSource>(
          () => ProgramDataSource(locator<FirebaseFirestore>()));

  // User DataSource 등록
  locator.registerLazySingleton<UsersDataSource>(
          () => UsersDataSource(locator<FirebaseFirestore>(), locator<FirebaseAuth>()));

  // Repository 등록
  locator.registerLazySingleton<ProgramRepository>(
          () => ProgramRepository(locator<ProgramDataSource>()));

  locator.registerLazySingleton<UserRepository>(
          () => UserRepository(locator<UsersDataSource>(), locator<FirebaseAuth>()));

  // UseCase 등록
  locator.registerLazySingleton<ProgramUseCase>(
          () => ProgramUseCase(locator<ProgramRepository>()));

  locator.registerLazySingleton<UserUsecase>(
          () => UserUsecase(locator<UserRepository>()));
}
