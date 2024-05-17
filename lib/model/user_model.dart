// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  String email;
  String? userName = "";
  String? phoneNumber = "";
  String profilURL =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS6O3NpGio51d-L_X--ggYNmTbN7STAn262kSrtu5zuw&s";
  DateTime? createdAt;
  DateTime? updatedAt;

  AppUser({required this.userId, required this.email,this.phoneNumber,this.userName});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email ?? "",
      "userName": userName ?? "",
      "phoneNumber": phoneNumber ?? "",
      "profilURL": profilURL ?? "",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp()
    };
  }

  AppUser.fromMap(Map<String, dynamic> map)
      : userId = map["userID"],
        email = map["email"],
        userName = map["userName"],
        profilURL = map["profilURL"],
        phoneNumber = map["phoneNumber"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate();

  @override
  String toString() {
    return 'AppUser(userId: $userId, email: $email, userName: $userName, phoneNumber: $phoneNumber, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
