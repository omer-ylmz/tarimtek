import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  String? email;
  String? userName;
  String? phoneNumber;
  String? profilURL;
  DateTime? createdAt;
  DateTime? updatedAt;

  AppUser({
    required this.userId,
    required this.email,
    this.phoneNumber,
    this.userName,
    this.profilURL,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email ?? "",
      "userName": userName ?? "",
      "phoneNumber": phoneNumber ?? "",
      "profilURL": profilURL ??
          "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map["userId"],
      email: map["email"],
      userName: map["userName"],
      phoneNumber: map["phoneNumber"],
      profilURL: map["profilURL"],
      createdAt: (map["createdAt"] as Timestamp?)?.toDate(),
      updatedAt: (map["updatedAt"] as Timestamp?)?.toDate(),
    );
  }

  AppUser.idveResim({
    required this.userId,
    required this.profilURL,
  });

  @override
  String toString() {
    return 'AppUser(userId: $userId, email: $email, userName: $userName, phoneNumber: $phoneNumber, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
