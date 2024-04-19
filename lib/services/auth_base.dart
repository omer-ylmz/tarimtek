import 'package:tarimtek/model/user_model.dart';

abstract class AuthBase {
  Future<AppUser?> currentUser();
  Future<AppUser?> signInAnonymusly();
  Future<bool> signOut();
}
