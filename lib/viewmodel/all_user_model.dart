import 'package:flutter/material.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<AppUser>? _tumKullanicilar;
}
