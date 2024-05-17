import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';

class FakeAuthentication implements AuthBase {
  String userID = "213215465465456";

  @override
  Future<AppUser?> currentUser() async {
    return Future.value(AppUser(userId: userID,email: "fakeuser@fake.com"));
  }

  @override
  Future<AppUser?> signInAnonymusly() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        AppUser(userId: userID,email: "fakeuser@fake.com");
        return null;
      },
    );
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        AppUser(userId: "google_user_id_1234567",email: "fakeuser@fake.com");
        return null;
      },
    );
  }

  @override
  Future<AppUser?> createUserInWithEmailPassword(
      String adSoyad, String numara, String email, String sifre) async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        AppUser(userId: "created_user_id_12345678",email: "fakeuser@fake.com");
        return null;
      },
    );
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        AppUser(userId: "sign_in_email_user_id_12345678",email: "fakeuser@fake.com");
        return null;
      },
    );
  }
}
