import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/services/database_base.dart';
import 'package:tarimtek/services/firestore_db_service.dart';

enum IlanState { idle, busy }

class IlanModel with ChangeNotifier {
  IlanState _state = IlanState.idle;
  final DBBase _dbBase = FirestoreDBService();
  List<Ilan> _ilanlar = [];

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
}
