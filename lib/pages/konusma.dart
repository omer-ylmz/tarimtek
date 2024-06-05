// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
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
  var _mesajController = TextEditingController();

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
                  itemCount: tumMesajlar!.length,
                  itemBuilder: (context, index) {
                    return Text(tumMesajlar[index].mesaj);
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
}
