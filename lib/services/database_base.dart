import 'package:tarimtek/model/user_model.dart';

abstract class DBBase {
  Future<bool?> saveUser(AppUser user);
}
