// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/repository/user_repository.dart';
import 'package:tarimtek/services/auth_base.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.idle;
  final UserRepository _userRepository = locator<UserRepository>();
  AppUser? _user;
  String emailHataMesaji = "";
  String sifreHataMesaji = "";
  String sifreTekrarHataMesaji = "";

  AppUser? get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners(); // Durum değiştiğinde dinleyicilere haber ver
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<AppUser?> currentUser() async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("Vİewmodeldeki currenuser da hata $e");
      return null;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> signInAnonymusly() async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.signInAnonymusly();
      return _user;
    } catch (e) {
      debugPrint("Vİewmodeldeki signIn da hata $e");
      return null;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("Vİewmodeldeki signOut  da hata $e");
      return false;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("Vİewmodeldeki signIn da hata $e");
      return null;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> createUserInWithEmailPassword(
      String adSoyad, String numara, String email, String sifre) async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.createUserInWithEmailPassword(
        adSoyad,
        numara,
        email,
        sifre,
      );
      return _user;
    } catch (e) {
      debugPrint("Vİewmodeldeki current user hata1 $e $_user");
      return null; // Hata durumunda null döndür
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
        _user = await _userRepository.signInWithEmailPassword(email, sifre);
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Vİewmodeldeki signİn email user hata $e");
      return null;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  bool _emailSifreKontrol(
    String email,
    String sifre,
  ) {
    var sonuc = true;

    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmali";
      sonuc = false;
    }
    if (!email.contains("@")) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    }
    return sonuc;
  }
}
