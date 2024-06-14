// ignore_for_file: constant_identifier_names, prefer_const_declarations, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/mesaj.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/repository/user_repository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatModel with ChangeNotifier {
  List<Mesaj>? _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 10;
  final UserRepository _userRepository = locator<UserRepository>();
  Mesaj? enSonGetirilenMesaj;
  Mesaj? _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinleyenListener = false;
  StreamSubscription? _streamSubscription;

  final AppUser currentUser;
  final AppUser sohbetEdilenUser;
  String? userName;

  bool get hasMoreLoading => _hasMore;

  List<Mesaj>? get mesajlarListesi => _tumMesajlar;
  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners(); // Durum değiştiğinde dinleyicilere haber ver
  }

  @override
  void dispose() {
    _streamSubscription!.cancel();
    super.dispose();
  }

  ChatModel({
    required this.currentUser,
    required this.sohbetEdilenUser,
    this.userName,
  }) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar!.isNotEmpty) {
      enSonGetirilenMesaj = _tumMesajlar!.last;
    }
    if (!yeniMesajlarGetiriliyor) state = ChatViewState.Busy;

    var getirilenMesajlar = await _userRepository.getMessageWithPagination(
      currentUser.userId,
      sohbetEdilenUser.userId,
      sayfaBasinaGonderiSayisi,
      enSonGetirilenMesaj,
    );

    if (getirilenMesajlar!.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _tumMesajlar!.addAll(getirilenMesajlar);
    if (_tumMesajlar!.isNotEmpty) {
      _listeyeEklenenIlkMesaj = _tumMesajlar!.first;
    }

    state = ChatViewState.Loaded;

    if (_yeniMesajDinleyenListener == false) {
      _yeniMesajDinleyenListener = true;
      yeniMesajListenerAta();
    }
  }

  Future<bool?> saveMessages(Mesaj kaydedilecekMesaj) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj);
  }

  Future<void> dahaFazlaMesajGetir() async {
    if (_hasMore) {
      getMessageWithPagination(true);
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  void yeniMesajListenerAta() {
    _streamSubscription = _userRepository
        .getMessages(currentUser.userId, sohbetEdilenUser.userId)
        .listen((anlikData) {
      if (anlikData!.isNotEmpty) {
        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar!.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj!.date!.millisecondsSinceEpoch !=
              anlikData[0].date!.millisecondsSinceEpoch)
            _tumMesajlar!.insert(0, anlikData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}
