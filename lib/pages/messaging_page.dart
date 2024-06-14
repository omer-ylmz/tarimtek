// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/konusma.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:tarimtek/pages/kullanicilar_page.dart';
import 'package:tarimtek/viewmodel/chat_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  // Konuşma verilerini kullanıcı detayları ile birlikte alır
  Future<Konusma> _getKonusmaWithUserDetails(DocumentSnapshot doc) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    var konusma = Konusma.fromMap(doc.data() as Map<String, dynamic>);

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(konusma.kimle_konusuyor)
        .get();
    konusma.konusulanUserName = userDoc['userName'];
    konusma.konusulanUserProfilURL = userDoc['profilURL'];

    return konusma;
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: const Text("Mesajlarım"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KullanicilarSayfasi(),
                    )),
                child: const Icon(Icons.people)),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("konusmalar")
            .where("konusma_sahibi", isEqualTo: _userModel.user!.userId)
            .orderBy("olusturulma_tarihi", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = snapshot.data!.docs;
            if (tumKonusmalar.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemCount: tumKonusmalar.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: _getKonusmaWithUserDetails(tumKonusmalar[index]),
                      builder:
                          (context, AsyncSnapshot<Konusma> konusmaSnapshot) {
                        if (!konusmaSnapshot.hasData) {
                          return const ListTile(
                            title: Text("Yükleniyor..."),
                          );
                        } else {
                          var oAnkiKonusma = konusmaSnapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider<ChatModel>(
                                    create: (context) => ChatModel(
                                      currentUser: _userModel.user!,
                                      userName:
                                          oAnkiKonusma.konusulanUserName ??
                                              'Bilinmeyen Kullanıcı',
                                      sohbetEdilenUser: AppUser.idveResim(
                                          userId: oAnkiKonusma.kimle_konusuyor!,
                                          profilURL: oAnkiKonusma
                                              .konusulanUserProfilURL),
                                    ),
                                    child: const KonusmaPage(),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  oAnkiKonusma.konusulanUserName ??
                                      'Bilinmeyen Kullanıcı',
                                  style: Sabitler.yaziStyleSiyahBaslik,
                                ),
                                subtitle: Text(
                                  oAnkiKonusma.son_yollanan_mesaj ??
                                      'Mesaj yok',
                                  style: Sabitler.yaziStyleSiyahAltBaslik,
                                ),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        oAnkiKonusma.konusulanUserProfilURL!)),
                              ),
                            ),
                          );
                        }
                      },
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
                            Icons.chat,
                            color: Sabitler.ikinciRenk,
                            size: 80,
                          ),
                          Text(
                            "Henüz Konuşma Yok",
                            style: Sabitler.yaziMorStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onRefresh: () => _konusmalarimListesiniYenile(),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }
}
