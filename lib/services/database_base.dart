import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/model/konusma.dart';
import 'package:tarimtek/model/mesaj.dart';
import 'package:tarimtek/model/user.dart';

abstract class DBBase {
  Future<bool?> saveUser(AppUser user);
  Future<AppUser?> readUser(String userID);
  Future<bool?> updateUserName(String userID, String yeniUserName);
  Future<bool?> updatePhoneNumber(String userID, String yeniPhoneNumber);
  Future<bool?> updateProfilFoto(String userID, String? profilFotoURL);
  Future<List<AppUser>?> getAllUsers();
  Future<List<AppUser>?> getUserWithPagination(
      AppUser enSonGetirilenUser, int getirilecekElemanSayisi);
  Future<List<Konusma>?> getAllConversations(String userID);
  Stream<List<Mesaj>?> getMessages(
      String currentUserID, String konusulanUserID);
  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime?> saatiGoster(String userID);
  Future<bool?> saveAdvert(Ilan ilan);
  Future<List<Ilan>>? getAllAdverts();
  Future<List<Ilan>?> getIlanWithPagination(
      Ilan? enSonGetirilenIlan, int getirilecekElemanSayisi,);
}
