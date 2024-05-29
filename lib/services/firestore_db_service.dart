// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<AppUser?> readUser(String userID) async {
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

  updateProfilFoto(String userID, String? profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"profilURL": profilFotoURL});
  }
}

  // Future<bool> checkEmailExists(String email) async {
  //   // E-posta adresi veritabanında mevcut mu kontrol et
  //   QuerySnapshot querySnapshot = await _firebaseauth.collection("users").where("email", isEqualTo: email).get();
  //   return querySnapshot.docs.isNotEmpty;
  // }

