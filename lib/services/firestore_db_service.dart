// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_print, body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/model/konusma.dart';
import 'package:tarimtek/model/mesaj.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool?> saveUser(AppUser user) async {
    await _firebaseDB.collection("users").doc(user.userId).set(user.toMap());

    DocumentSnapshot _okunanUser =
        await _firebaseDB.doc("users/${user.userId}").get();

    Map<String, dynamic>? _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>?;
    AppUser _okunanUserBilgileriNesne =
        AppUser.fromMap(_okunanUserBilgileriMap!);

    print("Okunan user nesensi: " + _okunanUserBilgileriNesne.toString());

    return true;
  }

  @override
  Future<AppUser?> readUser(String? userID) async {
    try {
      // "users" koleksiyonuna referans alıyoruz
      CollectionReference<Map<String, dynamic>> userRef =
          _firebaseDB.collection("users");

      // Belirli bir kullanıcı belgesine referans alıyoruz
      DocumentReference<Map<String, dynamic>> user = userRef.doc(userID);

      // Belgeyi alıyoruz
      DocumentSnapshot<Map<String, dynamic>> snapshot = await user.get();

      // Eğer belge mevcutsa
      if (snapshot.exists) {
        // Verileri alıyoruz
        Map<String, dynamic>? data = snapshot.data();
        if (data != null) {
          // Verileri AppUser nesnesine dönüştürüp geri döndürüyoruz
          AppUser _okunanUserNesnesi = AppUser.fromMap(data);
          print("okunan user nesnesi :" + _okunanUserNesnesi.toString());
          return _okunanUserNesnesi;
        } else {
          print('User data is null.');
          return null;
        }
      } else {
        print('No such user document.');
        return null;
      }
    } catch (e) {
      // Hata durumunda hatayı yazdır ve null döndür
      print('Error reading user: $e');
      return null;
    }
  }

  @override
  Future<bool?> updatePhoneNumber(String userID, String yeniPhoneNumber) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"phoneNumber": yeniPhoneNumber});
  }

  @override
  Future<bool?> updateUserName(String userID, String yeniUserName) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"userName": yeniUserName});
  }

  @override
  Future<bool?> updateProfilFoto(String userID, String? profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"profilURL": profilFotoURL});
  }

  @override
  Future<List<AppUser>?> getAllUsers() async {
    QuerySnapshot querySnapshot = await _firebaseDB.collection("users").get();
    List<AppUser> users = [];

    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      Map<String, dynamic> userData = tekUser.data() as Map<String, dynamic>;
      AppUser _tekUser = AppUser.fromMap(userData);
      users.add(_tekUser);
    }

    return users;
  }

  @override
  Stream<List<Mesaj>?> getMessages(
      String currentUserID, String konusulanUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .doc(currentUserID + "--" + konusulanUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  @override
  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").doc().id;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMesajYapisi = kaydedilecekMesaj.toMap();

    await _firebaseDB
        .collection("konusmalar")
        .doc(_myDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajYapisi);

    await _firebaseDB.collection("konusmalar").doc(_myDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    _kaydedilecekMesajYapisi.update("bendenMi", (value) => false);

    await _firebaseDB
        .collection("konusmalar")
        .doc(_receiverDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajYapisi);

    await _firebaseDB.collection("konusmalar").doc(_receiverDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    return true;
  }

  @override
  Future<List<Konusma>?> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    List<Konusma> tumKonusmalar = [];
    for (DocumentSnapshot tekKonusma in querySnapshot.docs) {
      Konusma _tekKonusma =
          Konusma.fromMap(tekKonusma.data() as Map<String, dynamic>);
      tumKonusmalar.add(_tekKonusma);
    }
    return tumKonusmalar;
  }

  @override
  Future<DateTime?> saatiGoster(String userID) async {
    // Firestore'a sunucu zaman damgasını yaz
    await _firebaseDB.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });

    // Sunucu zaman damgasını içeren belgeyi al
    var okunanMap = await _firebaseDB.collection("server").doc(userID).get();

    // Belgeden zaman damgasını al
    return okunanMap.data()?["saat"];
  }

  @override
  Future<List<AppUser>?> getUserWithPagination(
      AppUser? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    late QuerySnapshot _querySnapshot;
    List<AppUser> tumKullanicilar = [];
    if (enSonGetirilenUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();
      await Future.delayed(const Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      AppUser user = AppUser.fromMap(snap.data() as Map<String, dynamic>);

      tumKullanicilar.add(user);
    }
    return tumKullanicilar;
  }

  Future<List<Mesaj>>? getMessageWithPagination(
      String? currentUserID,
      String? sohberEdilenUserID,
      int? getirilecekElemanSayisi,
      Mesaj? enSonGetirilenMesaj) async {
    late QuerySnapshot _querySnapshot;
    List<Mesaj> tumMesajlar = [];
    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID! + "--" + sohberEdilenUserID!)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi!)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID! + "--" + sohberEdilenUserID!)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi!)
          .get();
      await Future.delayed(const Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Mesaj _tekMesaj = Mesaj.fromMap(snap.data() as Map<String, dynamic>);

      tumMesajlar.add(_tekMesaj);
    }
    return tumMesajlar;
  }

  @override
  Future<bool?> saveAdvert(Ilan ilan) async {
    var _ilanID = _firebaseDB
        .collection("ilanlar")
        .doc()
        .id; // Rastgele ilan ID'si oluştur
    var _kaydedilecekIlanYapisi = ilan.toMap();
    await _firebaseDB
        .collection("ilanlar")
        .doc(_ilanID)
        .set(_kaydedilecekIlanYapisi);

    return true;
  }

  @override
  Future<List<Ilan>>? getAllAdverts() async {
    var querySnapshot = await _firebaseDB.collection('ilanlar').get();
    return querySnapshot.docs.map((doc) => Ilan.fromMap(doc.data())).toList();
  }

  @override
  Future<List<Ilan>?> getIlanWithPagination(
    Ilan? enSonGetirilenIlan,
    int getirilecekElemanSayisi,
  ) async {
    late QuerySnapshot _querySnapshot;
    List<Ilan> tumIlanlar = [];

    if (enSonGetirilenIlan == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("ilanlar")
          .orderBy("olusturulma_tarihi")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("ilanlar")
          .orderBy("olusturulma_tarihi")
          .startAfter([enSonGetirilenIlan.olusturulma_tarihi])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(const Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Ilan ilan = Ilan.fromMap(snap.data() as Map<String, dynamic>);
      tumIlanlar.add(ilan);
    }

    return tumIlanlar;
  }
}
