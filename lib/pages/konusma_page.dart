// ignore: depend_on_referenced_packages, implementation_imports
// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

// ignore: depend_on_referenced_packages, implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/mesaj.dart';
import 'package:tarimtek/viewmodel/chat_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class KonusmaPage extends StatefulWidget {
  KonusmaPage({super.key});

  @override
  State<KonusmaPage> createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  final _mesajController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    final _chatModel = Provider.of<ChatModel>(context);
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: Text(
          "${_chatModel.sohbetEdilenUser.userName ?? _chatModel.userName}",
          style: Sabitler.yaziStyleSiyah,
        ),
      ),
      body: _chatModel.addListener == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  _buildMesajListesi(),
                  _buildYeniMesajGir(),
                ],
              ),
            ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatModel>(
      builder: (context, chatModel, child) {
        if (chatModel.mesajlarListesi != null) {
          return Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: chatModel.hasMoreLoading
                  ? chatModel.mesajlarListesi!.length + 1
                  : chatModel.mesajlarListesi!.length,
              itemBuilder: (context, index) {
                if (chatModel.hasMoreLoading == true &&
                    chatModel.mesajlarListesi!.length == index) {
                  return _yeniElemanlarYukleniyorIndicator();
                } else {
                  return _KonusmaBalonuOlustur(
                      chatModel.mesajlarListesi![index]);
                }
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
      },
    );
  }

  Container _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatModel>(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _mesajController,
              cursorColor: Sabitler.sariRenk,
              style: Sabitler.yaziMorStyle,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Mesajınızı Yazın",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Sabitler.ikinciRenk,
              child: const Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_mesajController.text.trim().isNotEmpty) {
                  Mesaj _kaydedilecekMesaj = Mesaj(
                      kimden: _chatModel.currentUser.userId,
                      kime: _chatModel.sohbetEdilenUser.userId,
                      bendenMi: true,
                      mesaj: _mesajController.text);
                  var sonuc = await _chatModel.saveMessages(_kaydedilecekMesaj);
                  if (sonuc == true) {
                    _mesajController.clear();
                    _scrollController.animateTo(0.0,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.easeOut);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _KonusmaBalonuOlustur(Mesaj oAnkiMesaj) {
    var _benimMesajimMi = oAnkiMesaj.bendenMi;
    var _saatDakikaDegeri = "";
    final _chatModel = Provider.of<ChatModel>(context);

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oAnkiMesaj.date);
      // ignore: empty_catches
    } catch (e) {}

    if (_benimMesajimMi) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Sabitler.ikinciRenk),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(4),
              child: Text(
                oAnkiMesaj.mesaj,
                style: Sabitler.yaziMorStyle,
              ),
            ),
            Text(_saatDakikaDegeri)
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetEdilenUser.profilURL!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Sabitler.ikinciRenk),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      oAnkiMesaj.mesaj,
                      style: Sabitler.yaziMorStyle,
                    ),
                  ),
                ),
              ],
            ),
            Text(_saatDakikaDegeri)
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date!.toDate());
    return _formatlanmisTarih;
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));

    return null;
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async {
    final _chatModel = Provider.of<ChatModel>(context, listen: false);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  Widget _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
