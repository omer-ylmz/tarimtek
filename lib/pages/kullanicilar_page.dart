// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, unused_element, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/viewmodel/all_user_model.dart';
import 'package:tarimtek/viewmodel/chat_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class KullanicilarSayfasi extends StatefulWidget {
  const KullanicilarSayfasi({super.key});

  @override
  State<KullanicilarSayfasi> createState() => _KullanicilarSayfasiState();
}

class _KullanicilarSayfasiState extends State<KullanicilarSayfasi> {
  bool _isLoading = false;
  bool _hasMore = true;
  int _sayfadakiGetirilecekElemanSayisi = 10;
  AppUser? _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener((_listeScrollListener));
  }

  @override
  Widget build(BuildContext context) {
    final _tumKullanicilarModel = Provider.of<AllUserModel>(context);
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: const Text("Kullanıcılar"),
      ),
      body: Consumer<AllUserModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: model.hasMoreLoading
                    ? model.kullanicilarListesi!.length + 1
                    : model.kullanicilarListesi!.length,
                itemBuilder: (context, index) {
                  if (model.kullanicilarListesi!.length == 1) {
                    return _kullaniciYok();
                  } else if (model.hasMoreLoading &&
                      index == model.kullanicilarListesi!.length) {
                    return _yeniElemanlarYukleniyorIndicator();
                  } else {
                    return _userListeElemaniOlustur(index);
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }


  Future<void> _refreshUserListYoksa() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _tumKullanicilarModel =
        Provider.of<AllUserModel>(context, listen: false);

    var oAnkiUser = _tumKullanicilarModel.kullanicilarListesi![index];
    if (oAnkiUser.userId == _userModel.user!.userId) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<ChatModel>(
              create: (context) => ChatModel(
                  currentUser: _userModel.user!, sohbetEdilenUser: oAnkiUser),
              child: const KonusmaPage(
                  ),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(
            oAnkiUser.userName!,
            style: Sabitler.yaziStyleSiyahBaslik,
          ),
          subtitle: Text(
            oAnkiUser.email!,
            style: Sabitler.yaziStyleSiyahAltBaslik,
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(oAnkiUser.profilURL!),
          ),
        ),
      ),
    );
  }

  Widget _yeniElemanlarYukleniyorIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarModel = Provider.of<AllUserModel>(context);
      _tumKullanicilarModel.dahaFazlaUserGetir();
      _isLoading = false;
    }
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      dahaFazlaKullaniciGetir();
    }
  }

  Widget _kullaniciYok() {
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
                  color: Colors.green,
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
      onRefresh: _refreshUserListYoksa,
    );
  }
}
