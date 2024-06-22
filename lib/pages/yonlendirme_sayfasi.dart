// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tarimtek/common-package/platform_duyarli_alert_dialog.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/advertise_page.dart';
import 'package:tarimtek/pages/messaging_page.dart';
import 'package:tarimtek/pages/navigaton_bar/my_custom_bottom_navi.dart';
import 'package:tarimtek/pages/navigaton_bar/tab_items.dart';
import 'package:tarimtek/pages/news_warning_page.dart';
import 'package:tarimtek/pages/profile.dart';
import 'package:tarimtek/pages/home_page.dart';

class Yonlendirme extends StatefulWidget {
  final AppUser user;

  const Yonlendirme({super.key, required this.user});

  @override
  State<Yonlendirme> createState() => _HomePageState();
}

class _HomePageState extends State<Yonlendirme> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TabItem _currentTab = TabItem.Anaekran;

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Anaekran: HomePage(user: widget.user),
      TabItem.Uyari:  NewsWarningPage(),
      TabItem.Ilanverme: const AdvertisePage(),
      TabItem.Mesajlasma: const MessagingPage(),
      TabItem.Profil: const ProfilePage()
    };
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı izin verdi');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Kullanıcı geçici izin verdi');
    } else {
      print('Kullanıcı izin vermedi veya kabul etmedi');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      if (message.notification != null) {
        print('Mesaj bildirim içeriyor: ${message.notification}');
        PlatformDuyarliAlertDialog(
          baslik: message.data["title"],
          icerik: message.data["body"],
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Uygulama açıkken mesaj açıldı: ${message.data}");
      PlatformDuyarliAlertDialog(
        baslik: message.data["title"],
        icerik: message.data["body"],
        anaButonYazisi: "Tamam",
      ).goster(context);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Arka planda mesaj alındı: ${message.data}");
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomNavigaton(
      sayfaOlusturucu: tumSayfalar(),
      currentTab: _currentTab,
      onSelectedTab: (secilenTab) {
        setState(() {
          _currentTab = secilenTab;
        });
        debugPrint("Seçilen sekme: $secilenTab");
      },
    );
  }
}
