import 'package:flutter/material.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/repository/user_repository.dart';

enum AllIlanViewState { Idle, Loaded, Busy }

class AllIlanModel with ChangeNotifier {
  AllIlanViewState _state = AllIlanViewState.Idle;
  List<Ilan>? _tumIlanlar;
  Ilan? _enSonGetirilenIlan;
  static const int sayfaBasinaGonderiSayisi = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;
  List<Ilan>? get ilanlarListesi => _tumIlanlar;
  AllIlanViewState get state => _state;

  final UserRepository _userRepository = locator<UserRepository>();

  set state(AllIlanViewState value) {
    _state = value;
    notifyListeners();
  }

  AllIlanModel() {
    _tumIlanlar = [];
    _enSonGetirilenIlan = null;
    getIlanWithPagination(null, false);
  }

  Future<void> getIlanWithPagination(Ilan? enSonGetirilenIlan, bool yeniElemanlarGetiriliyor) async {
    if (!_hasMore && !yeniElemanlarGetiriliyor) {
      return;
    }
    if (_tumIlanlar!.isNotEmpty) {
      _enSonGetirilenIlan = _tumIlanlar!.last;
    }
    if (!yeniElemanlarGetiriliyor) {
      state = AllIlanViewState.Busy;
    }
    await Future.delayed(const Duration(seconds: 1));
    var yeniListe = await _userRepository.getIlanWithPagination(_enSonGetirilenIlan, sayfaBasinaGonderiSayisi);
    if (yeniListe!.isEmpty) {
      _hasMore = false;
    } else {
      _tumIlanlar!.addAll(yeniListe);
      if (yeniListe.length < sayfaBasinaGonderiSayisi) {
        _hasMore = false;
      }
    }
    state = AllIlanViewState.Loaded;
  }

  Future<void> dahaFazlaIlanGetir() async {
    if (_hasMore) {
      await getIlanWithPagination(_enSonGetirilenIlan, true);
    }
  }

  Future<void> refresh() async {
    _hasMore = true;
    _enSonGetirilenIlan = null;
    _tumIlanlar = [];
    await getIlanWithPagination(null, false);
  }
}
