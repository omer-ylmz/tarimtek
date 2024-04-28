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
}
