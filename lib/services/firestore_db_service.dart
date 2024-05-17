import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseauth = FirebaseFirestore.instance;

  @override
  Future<bool?> saveUser(AppUser user) async {
    await _firebaseauth.collection("users").doc(user.userId).set(user.toMap());

    DocumentSnapshot _okunanUser =
        await _firebaseauth.doc("users/${user.userId}").get();

    Map<String, dynamic>? _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>?;
    AppUser _okunanUserBilgileriNesne =
        AppUser.fromMap(_okunanUserBilgileriMap!);

  print("Okunan user nesensi: "+_okunanUserBilgileriNesne.toString());

    return true;
  }
}
