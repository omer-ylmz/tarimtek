import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/sehir.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/pages/advertise_detay.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class AdvertisePage extends StatefulWidget {
  const AdvertisePage({super.key});

  @override
  State<AdvertisePage> createState() => _AdvertisePageState();
}

class _AdvertisePageState extends State<AdvertisePage> {
  String isPozisyonu = 'Seçilen Değer Yok';
  String isSuresi = 'Seçilen Değer Yok';
  String _ilanTanimi = ''; // Kullanıcı tarafından girilen iş tanımı metni
  String? _selectedIl;
  String? _selectedIlce;
  String _isUcreti = ''; // Kullanıcı tarafından girilen iş ücreti metni
  Ilan? _girilenIlan;

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        backgroundColor: Sabitler.arkaplan,
        appBar: AppBar(
          backgroundColor: Sabitler.arkaplan,
          title: Center(
            child: Text(
              "Bir İlan Verin",
              style: Sabitler.baslikStyleKucuk,
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İş Tanımı',
                          style: Sabitler
                              .ilanBaslikStyle, // İş tanımı başlık stili
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            style: Sabitler.ilanBaslikSecilenStyle,
                            decoration: InputDecoration(
                              hintText: 'İş tanımını buraya girin',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _ilanTanimi = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showSelectionModal(
                    context,
                    [
                      ilanSecenek(
                        context,
                        "Fındık Toplama İşçisi",
                        "Fındık hasat döneminde fındık ağaçlarından fındıkları toplayan işçi.",
                        true, // iş pozisyonu
                      ),
                      ilanSecenek(
                        context,
                        "Fındık Bahçe İşçisi",
                        "Fındık bahçelerinde genel bahçe bakımı ve düzenlemeleri yapan işçi.",
                        true, // iş pozisyonu
                      ),
                      ilanSecenek(
                        context,
                        "Fındık Sezon İşçisi",
                        "Fındık hasat dönemi süresince geçici olarak işe alınan işçi.",
                        true, // iş pozisyonu
                      ),
                      ListTile()
                    ],
                  ),
                  child: secenek("İş Pozisyonu", isPozisyonu),
                ),
                Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İşin Konumu',
                          style: Sabitler.ilanBaslikStyle,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                hint: Text("İli Seçiniz"),
                                value: _selectedIl,
                                style: Sabitler.ilanBaslikSecilenStyle,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedIl = newValue!;
                                    _selectedIlce = null;
                                  });
                                },
                                items: Konum.iller.map((String il) {
                                  return DropdownMenuItem<String>(
                                    value: il,
                                    child: Text(il),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: DropdownButton<String>(
                                hint: Text("İlçeyi Seçiniz"),
                                value: _selectedIlce,
                                style: Sabitler.ilanBaslikSecilenStyle,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                onChanged: _selectedIl == null
                                    ? null
                                    : (String? newValue) {
                                        setState(() {
                                          _selectedIlce = newValue!;
                                        });
                                      },
                                items: _selectedIl == null
                                    ? []
                                    : Konum.ilceler[_selectedIl!]!.map((ilce) {
                                        return DropdownMenuItem<String>(
                                          value: ilce,
                                          child: Text(ilce),
                                        );
                                      }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showSelectionModal(
                    context,
                    [
                      ilanSecenek(
                        context,
                        "Aylık",
                        "Aylık: 30 iş günü süresi.",
                        false, // iş süresi
                      ),
                      ilanSecenek(
                        context,
                        "Haftalık",
                        "Haftalık: 7 iş günü süresi.",
                        false, // iş süresi
                      ),
                      ilanSecenek(
                        context,
                        "Günlük",
                        "Günlük: Sabah 08:00 - Akşam 17:00 iş süresi.",
                        false, // iş süresi
                      ),
                      ListTile()
                    ],
                  ),
                  child: secenek("İşin Süresi", isSuresi),
                ),
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İşin Ücreti',
                          style: Sabitler
                              .ilanBaslikStyle, // İş ücreti başlık stili
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            style: Sabitler.ilanBaslikSecilenStyle,
                            decoration: InputDecoration(
                              hintText: 'Ücreti buraya girin',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isUcreti = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Sabitler.anaRenk)),
                    onPressed: () {
                      if (_validateInputs()) {
                        _girilenIlan = Ilan(
                            ilanSahibiId: _userModel.user!.userId,
                            ilanTanimi: _ilanTanimi,
                            isPozisyonu: isPozisyonu,
                            isSuresi: isSuresi,
                            isUcreti: _isUcreti,
                            selectedIl: _selectedIl,
                            selectedIlce: _selectedIlce);
                      }
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => AdversiteDetay(
                          ilan: _girilenIlan,
                        ),
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "İlanı Paylaş",
                          style: Sabitler.butonYaziStyleKapali,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  bool _validateInputs() {
    if (isPozisyonu == 'Seçilen Değer Yok' ||
        isSuresi == 'Seçilen Değer Yok' ||
        _ilanTanimi.isEmpty ||
        _selectedIl == null ||
        _selectedIlce == null ||
        _isUcreti.isEmpty) {
      _showErrorDialog('Lütfen tüm alanları doldurun.');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Card secenek(String secenekAdi, String atanacakDegisken) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        title: Text(
          secenekAdi,
          style: Sabitler.ilanBaslikStyle,
        ),
        subtitle: atanacakDegisken != 'Seçilen Değer Yok'
            ? Text(
                atanacakDegisken,
                style: Sabitler.ilanBaslikSecilenStyle,
              )
            : null,
        trailing: Icon(
          Icons.add_circle_outline,
          color: Sabitler.sariRenk,
        ),
      ),
    );
  }

  ListTile ilanSecenek(BuildContext context, String pozisyonAdi,
      String aciklama, bool isPozisyonuOption) {
    return ListTile(
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isPozisyonuOption && isPozisyonu == pozisyonAdi) ||
                  (!isPozisyonuOption && isSuresi == pozisyonAdi)
              ? Sabitler.sariRenk
              : Colors.grey,
        ),
      ),
      title: Text(
        pozisyonAdi,
        style: Sabitler.modelBottomBaslikStyle,
      ),
      subtitle: Text(
        aciklama,
        style: Sabitler.modelBottomAltBaslikStyle,
      ),
      onTap: () {
        setState(() {
          if (isPozisyonuOption) {
            isPozisyonu = pozisyonAdi;
          } else {
            isSuresi = pozisyonAdi;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  void _showSelectionModal(BuildContext context, List<Widget> options) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: options.map((Widget option) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: option,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
