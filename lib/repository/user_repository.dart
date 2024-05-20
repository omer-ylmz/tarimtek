import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';
import 'package:tarimtek/services/fake_auth_service.dart';
import 'package:tarimtek/services/firebase_auth_service.dart';
import 'package:tarimtek/services/firestore_db_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthentication _fakeAuthentication = locator<FakeAuthentication>();
  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  AppMode appMode = AppMode.release;

  @override
  Future<AppUser?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<AppUser?> signInAnonymusly() async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.signInAnonymusly();
    } else {
      return await _firebaseAuthService.signInAnonymusly();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.signInWithGoogle();
    } else {
      AppUser? _user = await _firebaseAuthService.signInWithGoogle();

      bool? _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc == true) {
        return _user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<AppUser?> createUserInWithEmailPassword(
    String adSoyad,
    String numara,
    String email,
    String sifre,
  ) async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.createUserInWithEmailPassword(
          adSoyad, numara, email, sifre);
    } else {
      AppUser? _user = await _firebaseAuthService.createUserInWithEmailPassword(
          adSoyad, numara, email, sifre);
      if (_user != null) {
        // _user değişkeni null değilse, işlemleri yap
        _user.phoneNumber = numara ?? "";
        _user.userName = adSoyad ?? "";

        bool? _sonuc = await _firestoreDBService.saveUser(_user);
        if (_sonuc == true) {
          return _user;
        }
      }
    }
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.signInWithEmailPassword(email, sifre);
    } else {
      return await _firebaseAuthService.signInWithEmailPassword(email, sifre);
    }
  }

  @override
  Future<AppUser?> changePassword(String email) async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.changePassword(email);
    } else {
      return await _firebaseAuthService.changePassword(email);
    }
  }
}
