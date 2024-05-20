// ignore_for_file: body_might_complete_normally_nullable, prefer_interpolation_to_compose_strings, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:google_sign_in/google_sign_in.dart';
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
    return AppUser(
        userId: user.uid, email: user.email!, phoneNumber: user.phoneNumber);
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
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print("SignOut Hata" + e.toString());
      return false;
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<AppUser?> createUserInWithEmailPassword(
      String adSoyad, String numara, String email, String sifre) async {
    try {
      UserCredential sonuc = await _auth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      var _myUser = sonuc.user;
      if (!_myUser!.emailVerified) {
        await _myUser.sendEmailVerification();
      } else {
        print("kullanıcın maili onaylanmış, ilgili sayfaya gidebilir.");
      }
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("current user hata" + e.toString());
    }
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    try {
      UserCredential sonuc =
          await _auth.signInWithEmailAndPassword(email: email, password: sifre);
      var _myUser = sonuc.user;
      if (_myUser!.emailVerified) {
        return _userFromFirebase(sonuc.user);
      } else {
        print("Email doğrulaması yapılmamış");
      }
    } catch (e) {
      print("Sign In email user hata" + e.toString());
    }
  }

  @override
  Future<AppUser?> changePassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Şifre sıfırlama e-postası başarıyla gönderildi
      print('Şifre sıfırlama e-postası gönderildi: $email');
    } catch (e) {
      // Hata durumunda hata mesajını yazdır
      print('Şifre sıfırlama e-postası gönderilemedi: $e');
    }
  }
}
