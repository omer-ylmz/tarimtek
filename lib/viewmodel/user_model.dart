// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user.dart';
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
      debugPrint("Viewmodeldeki signIn da hata $e");
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
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String sifre) async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.signInWithEmailPassword(email, sifre);
      return _user;
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  @override
  Future<AppUser?> changePassword(String email) async {
    try {
      state = ViewState.busy; // İşlem başladığında ViewState'i güncelle
      _user = await _userRepository.changePassword(email);
      return _user;
    } catch (e) {
      debugPrint("Vİewmodeldeki change Password Hata $e $_user");
      return null; // Hata durumunda null döndür
    } finally {
      state = ViewState.idle; // İşlem tamamlandığında ViewState'i güncelle
    }
  }

  Future<bool?> updateUserName(String userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc == true) {
      user!.userName = yeniUserName;
    }
    return sonuc;
  }

  Future<bool?> updatePhoneNumber(String userID, String yeniPhoneNumber) async {
    var sonuc =
        await _userRepository.updatePhoneNumber(userID, yeniPhoneNumber);
    if (sonuc == true) {
      user!.phoneNumber = yeniPhoneNumber;
    }
    return sonuc;
  }

  Future<String?> uploadFile(
      String userID, String fileType, File? profilFoto) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilFoto);

    return indirmeLinki;
  }
}
