import 'package:flutter/cupertino.dart';
import 'package:tarimtek/pages/navigaton_bar/tab_items.dart';

class MyCustomNavigaton extends StatelessWidget {
  const MyCustomNavigaton({
    super.key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.sayfaOlusturucu,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem.Anaekran),
          _navItemOlustur(TabItem.Uyari),
          _navItemOlustur(TabItem.Ilanverme),
          _navItemOlustur(TabItem.Mesajlasma),
          _navItemOlustur(TabItem.Profil)
        ],
        onTap: (value) => onSelectedTab(TabItem.values[value]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(
          builder: (context) {
            final sayfa = sayfaOlusturucu[gosterilecekItem];
            if (sayfa != null) {
              return sayfa;
            } else {
              return const Center(
                  child: Text('Sayfa bulunamadı')); // Varsayılan widget
            }
          },
        );
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab!.icon),
      label: olusturulacakTab!.title,
    );
  }
}
