// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sabitler {
  static const Color anaRenk = Color(0xFF0D0140);
  static const Color ikinciRenk = Color(0xff0d6cdfe);
  static const Color sariRenk = Color(0xff0ff9228);
  static Color arkaplan = Colors.grey.shade100;

  static const String baslikText = "Ortalama Hesapla";

  static final TextStyle baslikStyle = GoogleFonts.quicksand(
      fontSize: 30, fontWeight: FontWeight.w900, color: anaRenk);

  static final TextStyle baslikStyleKucuk = GoogleFonts.quicksand(
      fontSize: 24, fontWeight: FontWeight.w900, color: anaRenk);

  static final TextStyle baslikStyleKucukSari = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: sariRenk);

  static final TextStyle hataBaslikStyle = GoogleFonts.quicksand(
      fontSize: 20, fontWeight: FontWeight.w900, color: anaRenk);

  static final TextStyle yaziMorStyle = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: anaRenk);

  static final TextStyle yaziSariStyle = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: sariRenk);

  static final TextStyle butonYaziStyleKapali = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  static final TextStyle butonYaziStyleAcik = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: ikinciRenk);

  static final TextStyle digerStyle =
      GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w700);

  static final TextStyle yaziStyleBeyaz = GoogleFonts.quicksand(
      fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white);

  static final TextStyle yaziStyleSiyah = GoogleFonts.quicksand(
      fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black);

  static final TextStyle yaziStyleSiyahBaslik = GoogleFonts.quicksand(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);

  static final TextStyle yaziStyleSiyahAltBaslik = GoogleFonts.quicksand(
      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);

  static final TextStyle ilanBaslikStyle = GoogleFonts.quicksand(
      fontSize: 20, fontWeight: FontWeight.w700, color: anaRenk);

  static final TextStyle ilanBaslikSecilenStyle = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w700, color: sariRenk);

  static final TextStyle modelBottomBaslikStyle = GoogleFonts.quicksand(
      fontSize: 18, fontWeight: FontWeight.w700, color: anaRenk);

  static final TextStyle modelBottomAltBaslikStyle = GoogleFonts.quicksand(
      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black);

  static final TextStyle yaziStyleGriAltBaslik = GoogleFonts.quicksand(
      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey);

  static final TextStyle ilanDetayBaslikStyle = GoogleFonts.quicksand(
      fontSize: 24, fontWeight: FontWeight.w900, color: anaRenk);

  static final TextStyle ilanDetayBaslikStyleKucuk = GoogleFonts.quicksand(
      fontSize: 20, fontWeight: FontWeight.w700, color: anaRenk);

  static final TextStyle yaziStyleSiyahAltBaslikBuyuk = GoogleFonts.quicksand(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);

  static final TextStyle yaziStyleSiyahOkuma = GoogleFonts.quicksand(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
}
