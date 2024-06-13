import 'package:cloud_firestore/cloud_firestore.dart';

class Ilan {
  final String? ilanSahibiId;
  final String? isPozisyonu;
  final String? isSuresi;
  final String? ilanTanimi;
  final String? selectedIl;
  final String? selectedIlce;
  final String? isUcreti;
  final Timestamp? olusturulma_tarihi;

  Ilan({
    this.ilanSahibiId,
    this.isPozisyonu,
    this.isSuresi,
    this.ilanTanimi,
    this.selectedIl,
    this.selectedIlce,
    this.isUcreti,
    this.olusturulma_tarihi,
  });

  Map<String, dynamic> toMap() {
    return {
      "ilanSahibiId": ilanSahibiId,
      "isPozisyonu": isPozisyonu,
      "isSuresi": isSuresi,
      "ilanTanimi": ilanTanimi,
      "selectedIl": selectedIl,
      "selectedIlce": selectedIlce,
      "isUcreti": isUcreti,
      "olusturulma_tarihi": olusturulma_tarihi ?? FieldValue.serverTimestamp(),
    };
  }

  factory Ilan.fromMap(Map<String, dynamic> map) {
    return Ilan(
      ilanSahibiId: map["ilanSahibiId"],
      isPozisyonu: map["isPozisyonu"],
      isSuresi: map["isSuresi"],
      ilanTanimi: map["ilanTanimi"],
      selectedIl: map["selectedIl"],
      selectedIlce: map["selectedIlce"],
      isUcreti: map["isUcreti"],
      olusturulma_tarihi: map["olusturulma_tarihi"],
    );
  }

  @override
  String toString() {
    return 'Ilan(ilanSahibiId: $ilanSahibiId, isPozisyonu: $isPozisyonu, isSuresi: $isSuresi, ilanTanimi: $ilanTanimi, selectedIl: $selectedIl, selectedIlce: $selectedIlce, isUcreti: $isUcreti, olusturulma_tarihi: $olusturulma_tarihi)';
  }
}
