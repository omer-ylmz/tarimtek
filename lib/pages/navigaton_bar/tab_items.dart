// ignore: constant_identifier_names
// ignore_for_file: constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';

enum TabItem { Anaekran, Uyari, Ilanverme, Mesajlasma, Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Anaekran: TabItemData(title: "Ana Ekran", icon: Icons.home),
    TabItem.Uyari: TabItemData(title: "Haber ve Uyarı", icon: Icons.newspaper),
    TabItem.Ilanverme: TabItemData(
        title: "İlan Verme", icon: Icons.add_circle_outline_rounded),
    TabItem.Mesajlasma: TabItemData(title: "Mesajlaşma", icon: Icons.chat),
    TabItem.Profil: TabItemData(title: "Profil", icon: Icons.person)
  };
}
