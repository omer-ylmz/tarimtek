import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/common-package/platform_duyarli_alert_dialog.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPhoneNumber = TextEditingController();
  File? _profilFoto;
  final ImagePicker picker = ImagePicker();

  bool duzenleModu = false;

  @override
  void initState() {
    super.initState();
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _controllerUserName.text = _userModel.user!.userName!;
    _controllerPhoneNumber.text = _userModel.user!.phoneNumber!;
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    _controllerPhoneNumber.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
    try {
      XFile? _yeniResim = await picker.pickImage(source: ImageSource.camera);
      if (_yeniResim != null) {
        setState(() {
          _profilFoto = File(_yeniResim.path);
        });
      }
    } catch (e) {
      print("Kamera hatası: $e");
    }
  }

  void _galeridenResimCek() async {
    try {
      XFile? _yeniResim = await picker.pickImage(source: ImageSource.gallery);
      if (_yeniResim != null) {
        setState(() {
          _profilFoto = File(_yeniResim.path);
        });
      }
    } catch (e) {
      print("Galeri hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    print("profil sayfasındaki user bilgileri: ${_userModel.user.toString()}");
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.arkaplan,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 80,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    duzenleModu = true;
                  });
                },
                child: Text(
                  "Düzenle",
                  textAlign: TextAlign.center,
                  style: Sabitler.yaziMorStyle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: () => _cikisIcinOnayIste(context),
              child: Text(
                "Çıkış",
                textAlign: TextAlign.center,
                style: Sabitler.yaziMorStyle,
              ),
            ),
          )
        ],
        title: Text("Profil"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: duzenleModu
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 160,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera),
                                      title: Text("Kameradan Çek"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _kameradanFotoCek();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text("Galeriden Seç"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _galeridenResimCek();
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      : null,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage("${_userModel.user!.profilURL}")
                            as ImageProvider
                        : FileImage(_profilFoto!),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Opacity(
                  opacity: duzenleModu ? 1.0 : 1.0,
                  child: TextFormField(
                    controller: _controllerUserName,
                    readOnly: !duzenleModu,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text("Adınız"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Opacity(
                  opacity: duzenleModu ? 1.0 : 1.0,
                  child: TextFormField(
                    initialValue: _userModel.user!.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text("Emailiniz"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Opacity(
                  opacity: duzenleModu ? 1.0 : 1.0,
                  child: TextFormField(
                    controller: _controllerPhoneNumber,
                    readOnly: !duzenleModu,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text("Telefon Numaranız"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              if (duzenleModu)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _userNameGuncelle(context);
                            _profilFotoUpdated(context);
                            duzenleModu = false;
                          });
                        },
                        child: Text("Değişiklikleri Kaydet"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            duzenleModu = false;
                          });
                        },
                        child: Text("İptal"),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user!.userId, _controllerUserName.text);
    } else if (_userModel.user!.phoneNumber != _controllerPhoneNumber.text) {
      var updateResult = await _userModel.updatePhoneNumber(
          _userModel.user!.userId, _controllerPhoneNumber.text);
    }
    setState(() {
      _controllerPhoneNumber;
      _controllerUserName;
    });
  }

  void _profilFotoUpdated(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
    var url =  await _userModel.uploadFile(
          _userModel.user!.userId, "profil_foto", _profilFoto);
    }
  }
}

Future<bool> _cikisYap(BuildContext context) async {
  final _userModel = Provider.of<UserModel>(context, listen: false);
  bool sonuc = await _userModel.signOut();
  return sonuc;
}
