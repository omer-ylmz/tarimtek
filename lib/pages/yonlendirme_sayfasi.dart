// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/advertise_page.dart';
import 'package:tarimtek/pages/messaging_page.dart';
import 'package:tarimtek/pages/navigaton_bar/my_custom_bottom_navi.dart';
import 'package:tarimtek/pages/navigaton_bar/tab_items.dart';
import 'package:tarimtek/pages/news_warning_page.dart';
import 'package:tarimtek/pages/profile.dart';
import 'package:tarimtek/pages/home_page.dart';

// ignore: must_be_immutable
class Yonlendirme extends StatefulWidget {
  final AppUser user;

  const Yonlendirme({super.key, required this.user});

  @override
  State<Yonlendirme> createState() => _HomePageState();
}

class _HomePageState extends State<Yonlendirme> {
  TabItem _currentTab = TabItem.Anaekran;

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Anaekran: HomePage(user: widget.user),
      TabItem.Uyari: const NewsWarningPage(),
      TabItem.Ilanverme: const AdvertisePage(),
      TabItem.Mesajlasma: const MessagingPage(),
      TabItem.Profil: const ProfilePage()
    };
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
        debugPrint("Seçilen tab item:$secilenTab");
      },
    );
  }
}
