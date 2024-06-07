import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  Timestamp? date;

  Mesaj(
      {required this.kimden,
      required this.kime,
      required this.bendenMi,
      required this.mesaj,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      "kimden": kimden,
      "kime": kime,
      "bendenMi": bendenMi,
      "mesaj": mesaj,
      "date": date ?? FieldValue.serverTimestamp(),
    };
  }

  factory Mesaj.fromMap(Map<String, dynamic> map) {
    return Mesaj(
      kimden: map["kimden"],
      kime: map["kime"],
      bendenMi: map["bendenMi"],
      mesaj: map["mesaj"],
      date: map["date"],
    );
  }

  @override
  String toString() {
    return 'Mesaj(kimden: $kimden, kime: $kime, bendenMi: $bendenMi, mesaj: $mesaj, date: $date)';
  }
}
