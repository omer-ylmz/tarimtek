// ignore: depend_on_referenced_packages, implementation_imports
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore: depend_on_referenced_packages, implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/mesaj.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class Konusma extends StatefulWidget {
  final AppUser currentUser;
  final AppUser sohbetEdilenUser;
  const Konusma(
      {super.key, required this.currentUser, required this.sohbetEdilenUser});

  @override
  State<Konusma> createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  final _mesajController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    AppUser _currentUser = widget.currentUser;
    AppUser _sohbetEdilenUser = widget.sohbetEdilenUser;
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: Text(
          "${widget.sohbetEdilenUser.userName}",
          style: Sabitler.yaziStyleSiyah,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: _userModel.getMessages(
                  _currentUser.userId, _sohbetEdilenUser.userId),
              builder: (context, streamMesajlarListesi) {
                if (!streamMesajlarListesi.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var tumMesajlar = streamMesajlarListesi.data;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: tumMesajlar!.length,
                  itemBuilder: (context, index) {
                    return _konusmaBalonuOlustur(tumMesajlar[index]);
                  },
                );
              },
            )),
            Container(
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
                              kimden: _currentUser.userId,
                              kime: _sohbetEdilenUser.userId,
                              bendenMi: true,
                              mesaj: _mesajController.text);
                          var sonuc =
                              await _userModel.saveMessages(_kaydedilecekMesaj);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oAnkiMesaj) {
    var _benimMesajimMi = oAnkiMesaj.bendenMi;
    var _saatDakikaDegeri = "";

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
                      NetworkImage(widget.sohbetEdilenUser.profilURL!),
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
}
