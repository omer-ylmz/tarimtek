import 'package:tarimtek/model/user.dart';

abstract class AuthBase {
  Future<AppUser?> currentUser();
  Future<AppUser?> signInAnonymusly();
  Future<bool> signOut();
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> signInWithEmailPassword(String email, String sifre);
  Future<AppUser?> createUserInWithEmailPassword(
      String adSoyad, String numara, String email, String sifre);
  Future<AppUser?> changePassword(String email);
}
