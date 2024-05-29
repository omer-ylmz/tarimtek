// ignore_for_file: body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/services/auth_base.dart';
import 'package:tarimtek/services/fake_auth_service.dart';
import 'package:tarimtek/services/firebase_auth_service.dart';
import 'package:tarimtek/services/firebase_storage_service.dart';
import 'package:tarimtek/services/firestore_db_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthentication _fakeAuthentication = locator<FakeAuthentication>();
  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.release;

  @override
  Future<AppUser?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.currentUser();
    } else {
      AppUser? _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user!.userId);
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
        return await _firestoreDBService.readUser(_user.userId);
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
        _user.phoneNumber = numara;
        _user.userName = adSoyad;

        bool? _sonuc = await _firestoreDBService.saveUser(_user);
        if (_sonuc == true) {
          return await _firestoreDBService.readUser(_user.userId);
        }
      }
    }
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    if (appMode == AppMode.debug) {
      return await _fakeAuthentication.signInWithEmailPassword(email, sifre);
    } else {
      AppUser? _user =
          await _firebaseAuthService.signInWithEmailPassword(email, sifre);
      return _firestoreDBService.readUser(_user!.userId);
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

  Future<bool?> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.debug) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<bool?> updatePhoneNumber(String userID, String yeniPhoneNumber) async {
    if (appMode == AppMode.debug) {
      return false;
    } else {
      return await _firestoreDBService.updatePhoneNumber(
          userID, yeniPhoneNumber);
    }
  }

  Future<String?> uploadFile(
      String userID, String fileType, File? profilFoto) async {
    if (appMode == AppMode.debug) {
      return "dosya_indirme_linki";
    } else {
      var _profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto!);
          await _firestoreDBService.updateProfilFoto(
          userID, _profilFotoURL);
      return _profilFotoURL;
    }
  }
}
