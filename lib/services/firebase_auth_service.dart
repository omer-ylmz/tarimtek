// ignore_for_file: body_might_complete_normally_nullable, prefer_interpolation_to_compose_strings, avoid_print

import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AppUser?> currentUser() async {
    try {
      User? user = _auth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata Current User" + e.toString());
      return null;
    }
  }

  AppUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(userId: user.uid);
  }

  @override
  Future<AppUser?> signInAnonymusly() async {
    try {
      UserCredential sonuc = await _auth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Sign In Anonymously Hata" + e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print("SignOut Hata" + e.toString());
      return false;
    }
  }
}
