// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarimtek/common-package/platform_duyarli_widget.dart';
import 'package:tarimtek/constants/text_style.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String baslik;
  final String icerik;
  final String anaButonYazisi;
  final String? iptalButonYazisi;

  //todo bak hata olursa const ekledi
   const PlatformDuyarliAlertDialog(
      {super.key, required this.baslik,
      required this.icerik,
      required this.anaButonYazisi,
      this.iptalButonYazisi});

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
              context: context,
              builder: (context) => this,
            ) ??
            false
        : await showDialog<bool>(
              context: context,
              builder: (context) => this,
            ) ??
            false;
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        baslik,
        style: Sabitler.hataBaslikStyle,
      ),
      content: Text(
        icerik,
        style: Sabitler.yaziMorStyle,
      ),
      actions: _dialogButonlariAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        baslik,
        style: Sabitler.hataBaslikStyle,
      ),
      content: Text(
        icerik,
        style: Sabitler.yaziMorStyle,
      ),
      actions: _dialogButonlariAyarla(context),
    );
  }

  List<Widget> _dialogButonlariAyarla(BuildContext context) {
    final _tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        _tumButonlar.add(
          CupertinoDialogAction(
            child: Text(
              iptalButonYazisi!,
              style: Sabitler.yaziMorStyle,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      _tumButonlar.add(
        CupertinoDialogAction(
          child: Text(
            anaButonYazisi,
            style: Sabitler.yaziMorStyle,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    } else {
      if (iptalButonYazisi != null) {
        _tumButonlar.add(
          TextButton(
            child: Text(
              iptalButonYazisi!,
              style: Sabitler.yaziMorStyle,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      _tumButonlar.add(
        TextButton(
          child: Text(
            anaButonYazisi,
            style: Sabitler.yaziMorStyle,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    }

    return _tumButonlar;
  }
}
