import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';

class FakeAuthentication implements AuthBase {
  String userID = "213215465465456";

  @override
  Future<AppUser?> currentUser() async {
    return Future.value(AppUser(userId: userID));
  }

  @override
  Future<AppUser?> signInAnonymusly() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        AppUser(userId: userID);
        return null;
      },
    );
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<AppUser?> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> createUserInWithEmailPassword(
      String adSoyad, String numara, String email, String sifre) {
    // TODO: implement createUserInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) {
    // TODO: implement signInWithEmailPassword
    throw UnimplementedError();
  }
}
