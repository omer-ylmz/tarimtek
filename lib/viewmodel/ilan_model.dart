import 'package:flutter/material.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/repository/user_repository.dart';
import 'package:tarimtek/services/database_base.dart';
import 'package:tarimtek/services/firestore_db_service.dart';

enum IlanState { idle, busy }

class IlanModel with ChangeNotifier {
  IlanState _state = IlanState.idle;
  final DBBase _dbBase = FirestoreDBService();
  List<Ilan> _ilanlar = [];
  final UserRepository _userRepository = locator<UserRepository>();

  IlanState get state => _state;
  List<Ilan> get ilanlar => _ilanlar;

  set state(IlanState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> saveAdvert(Ilan ilan) async {
    try {
      state = IlanState.busy;
      var result = await _dbBase.saveAdvert(ilan);
      if (result!) {
        _ilanlar.add(ilan);
        notifyListeners();
      }
      return result;
    } finally {
      state = IlanState.idle;
    }
  }

  Future<void> getAllAdverts() async {
    try {
      state = IlanState.busy;
      _ilanlar = await _dbBase.getAllAdverts()!;
      notifyListeners();
    } finally {
      state = IlanState.idle;
    }
  }

  Future<List<Ilan>?> getIlanWithPagination(
      Ilan? enSonGetirilenIlan, int getirilecekElemanSayisi) async {
    return await _userRepository.getIlanWithPagination(
        enSonGetirilenIlan, getirilecekElemanSayisi);
  }
}
