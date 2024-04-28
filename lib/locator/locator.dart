import 'package:get_it/get_it.dart';
import 'package:tarimtek/repository/user_repository.dart';
import 'package:tarimtek/services/fake_auth_service.dart';
import 'package:tarimtek/services/firebase_auth_service.dart';

GetIt locator = GetIt.instance;

void setupLacator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthentication());
  locator.registerLazySingleton(() => UserRepository());
}
