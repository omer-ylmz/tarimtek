import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/pages/sign_in/sign_in_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _emailController = TextEditingController();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Parolanızı Mı Unuttunuz",
                style: Sabitler.baslikStyle,
              ),
              SizedBox(height: 20.0),
              Text(
                "Şifrenizi sıfırlamak için kimliği doğrulanabilen e-posta adresinize ihtiyacımız var.",
                style: Sabitler.yaziMorStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Image.asset(
                  "assets/images/sifre.JPG",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (newValue) {
                    setState(() {
                      email = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'E-posta',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Sabitler.anaRenk)),
                  onPressed: () => _resetPassword(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "PAROLAMI YENİLE",
                        style: Sabitler.butonYaziStyleKapali,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Sabitler.ikinciRenk)),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "GİRİŞE GERİ DÖN",
                        style: Sabitler.yaziMorStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (email.isEmpty) {
      _showSnackBar(context, 'Lütfen bir e-posta adresi girin');
      return;
    }

    try {
      await _userModel.changePassword(email);
      _showSnackBar(context, 'Şifre sıfırlama e-postası gönderildi');
    } catch (e) {
      _showSnackBar(context, 'Şifre sıfırlama e-postası gönderilemedi: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
