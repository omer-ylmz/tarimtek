// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tarimtek/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String?> uploadFile(
      String userID, String fileType, File yuklenecekDosya) async {
    final storage = storageRef.child(userID).child(fileType).child("profil_foto.png");
    var uploadTask = storage.putFile(yuklenecekDosya);

    try {
      var snapshot = await uploadTask;
      var url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
