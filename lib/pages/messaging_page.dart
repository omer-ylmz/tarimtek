// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    // Future getAllUsers is called only once
    Future<List<AppUser>?> allUsersFuture = _userModel.getAllUser();

    return Scaffold(
        appBar: AppBar(
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
                return ListView.builder(
                  itemCount: tumKullanicilar.length,
                  itemBuilder: (context, index) {
                    var oAnkiUser = tumKullanicilar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => Konusma(
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
                );
              } else {
                return Center(
                  child: Text(
                    "Kayıtlı bir kullanıcı yok",
                    style: Sabitler.yaziMorStyle,
                  ),
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
}
