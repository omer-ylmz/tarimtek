import 'package:tarimtek/model/user.dart';

abstract class DBBase {
  Future<bool?> saveUser(AppUser user);
  Future<AppUser?> readUser(String userID);
  Future<bool?> updateUserName(String userID, String yeniUserName);
  Future<bool?> updatePhoneNumber(String userID, String yeniPhoneNumber);
}
