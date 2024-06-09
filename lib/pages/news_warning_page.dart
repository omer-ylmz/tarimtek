// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class NewsWarningPage extends StatefulWidget {
  const NewsWarningPage({super.key});

  @override
  State<NewsWarningPage> createState() => _NewsWarningPageState();
}

class _NewsWarningPageState extends State<NewsWarningPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    // Future getAllUsers is called only once
    Future<List<AppUser>?> allUsersFuture = _userModel.getAllUser();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Sabitler.ikinciRenk,
          title: const Text("Mesajlaşma"),
        ),
        body: FutureBuilder<List<AppUser>?>(
          future: allUsersFuture,
          builder: (context, sonuc) {
            if (sonuc.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (sonuc.hasError) {
              return Center(
                child: Text(
                  "Bir hata oluştu: ${sonuc.error}",
                  style: Sabitler.yaziMorStyle,
                ),
              );
            } else if (sonuc.hasData) {
              var tumKullanicilar = sonuc.data!;
              // Filter out the current user
              tumKullanicilar.removeWhere(
                  (user) => user.userId == _userModel.user!.userId);

              if (tumKullanicilar.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: _kullanicilarListesiniGuncelle,
                  child: ListView.builder(
                    itemCount: tumKullanicilar.length,
                    itemBuilder: (context, index) {
                      var oAnkiUser = tumKullanicilar[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => KonusmaPage(
                              currentUser: _userModel.user!,
                              sohbetEdilenUser: oAnkiUser,
                            ),
                          ));
                        },
                        child: ListTile(
                          title: Text(oAnkiUser.userName!),
                          subtitle: Text(oAnkiUser.email!),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(oAnkiUser.profilURL!),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return RefreshIndicator(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.supervised_user_circle_sharp,
                              color: Sabitler.ikinciRenk,
                              size: 80,
                            ),
                            Text(
                              "Henüz Kullanıcı Yok",
                              style: Sabitler.yaziMorStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onRefresh: () => _kullanicilarListesiniGuncelle(),
                );
              }
            } else {
              return Center(
                child: Text(
                  "Kayıtlı bir kullanıcı yok",
                  style: Sabitler.yaziMorStyle,
                ),
              );
            }
          },
        ));
  }

  Future<Null> _kullanicilarListesiniGuncelle() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));

    return null;
  }
}
