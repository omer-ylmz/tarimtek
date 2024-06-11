import 'package:flutter/material.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/repository/user_repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<AppUser>? _tumKullanicilar;
  AppUser? _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  final UserRepository _userRepository = locator<UserRepository>();

  List<AppUser>? get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners(); // Durum değiştiğinde dinleyicilere haber ver
  }

  AllUserModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  //yeni eleman getir true yapılır refresh ve sayfalama için
  getUserWithPagination(
      AppUser? enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar!.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar!.last;
    }
    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }
    await Future.delayed(Duration(seconds: 1));
    var yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser, sayfaBasinaGonderiSayisi);
    if (yeniListe!.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _tumKullanicilar!.addAll(yeniListe);
    _hasMore = false;
    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
    if (!_hasMore) {
      getUserWithPagination(_enSonGetirilenUser, true);
    }
    await Future.delayed(Duration(seconds: 1));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }
}
