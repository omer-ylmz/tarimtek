// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class KullanicilarSayfasi extends StatefulWidget {
  const KullanicilarSayfasi({Key? key}) : super(key: key);

  @override
  State<KullanicilarSayfasi> createState() => _KullanicilarSayfasiState();
}

class _KullanicilarSayfasiState extends State<KullanicilarSayfasi> {
  List<AppUser> tumKullanicilar = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _sayfadakiGetirilecekElemanSayisi = 10;
  AppUser? _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getUser();
    });
    getUser();

    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
                _scrollController.position.minScrollExtent &&
            !_scrollController.position.outOfRange) {
          getUser();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: const Text("Kullanıcılar"),
      ),
      body: tumKullanicilar.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _kullaniciListesiniOlustur(),
    );
  }

  Future<void> getUser() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (!_hasMore || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<AppUser>? _users = await _userModel.getUserWithPagination(
      _enSonGetirilenUser,
      _sayfadakiGetirilecekElemanSayisi,
    );

    if (_users != null && _users.isNotEmpty) {
      setState(() {
        tumKullanicilar.addAll(_users);
        _enSonGetirilenUser = tumKullanicilar.last;
        if (_users.length < _sayfadakiGetirilecekElemanSayisi) {
          _hasMore = false;
        }
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _kullaniciListesiniOlustur() {
    if (tumKullanicilar.length > 1) {
      return RefreshIndicator(
        onRefresh: _refreshUserList,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: tumKullanicilar.length + 1,
          itemBuilder: (context, index) {
            if (index == tumKullanicilar.length) {
              return _yeniElemanlarYukleniyorIndicator();
            }
            return _userListeElemaniOlustur(index);
          },
        ),
      );
    } else {
      return RefreshIndicator(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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

  Future<Null> _refreshUserList() async {
    _hasMore = true;

    _enSonGetirilenUser = null;
    getUser();
  }

  Future<void> _refreshUserListYoksa() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    var oAnkiUser = tumKullanicilar[index];
    if (oAnkiUser.userId == _userModel.user!.userId) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => KonusmaPage(
              currentUser: _userModel.user!, sohbetEdilenUser: oAnkiUser),
        ));
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
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }
}
