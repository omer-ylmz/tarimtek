import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/yonlendirme_sayfasi.dart';
import 'package:tarimtek/pages/sign_in/change_password.dart';
import 'package:tarimtek/pages/sign_in/register_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool checkBoxValue = false;
  late FirebaseAuth auth;
  String _email = "";
  String _sifre = "";
  final _formKey = GlobalKey<FormState>();
  bool _sifreGizli = true;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    AppUser? user = await _userModel.signInAnonymusly();
    debugPrint("Oturum açan User ID${user!.userId.toString()}");
  }

  void _googleIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    AppUser? user = await _userModel.signInWithGoogle();
    debugPrint("Oturum açan User ID${user?.userId.toString()}");
  }

  void _mailIleGiris() async {
    bool _validate = _formKey.currentState!.validate();
    if (_validate) {
      _formKey.currentState!.save();
      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        AppUser? user =
            await _userModel.signInWithEmailPassword(_email, _sifre);
        debugPrint("Oturum açan User ID${user?.userId.toString()}");
        debugPrint("$_email  $_sifre");
        if (_userModel.state == ViewState.idle && user != null) {
          if (mounted) {
            // State hala "mounted" durumdaysa
            Future.delayed(const Duration(milliseconds: 10));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Yonlendirme(user: user),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        debugPrint("widgeteki hata yakalandı:" + e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: _userModel.state == ViewState.idle
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            "Hoş Geldiniz",
                            textAlign: TextAlign.center,
                            style: Sabitler.baslikStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            "Verimli bir tarım deneyimi için biz buradayız. Giriş yapın ve tarımın büyülü dünyasına adım atın.",
                            textAlign: TextAlign.center,
                            style: Sabitler.yaziMorStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  prefixIconColor: Sabitler.anaRenk,
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Email",
                                  hintText: "omeryilmaz@gmail.com",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                validator: (value) {
                                  if (EmailValidator.validate(value!)) {
                                    return null;
                                  } else {
                                    return "Hatalı mail adresi girişi yaptınız";
                                  }
                                },
                                onSaved: (deger) {
                                  setState(() {
                                    _email = deger!;
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              formAlaniSifre(
                                TextInputType.visiblePassword,
                                Icons.lock,
                                "Şifre",
                                "**********",
                                _sifre,
                                (value) => _sifre = value!,
                                yaziGizleme: _sifreGizli,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Text(
                                "Şifrenizi mi unuttunuz?",
                                style: Sabitler.yaziMorStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePassword(),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Sabitler.anaRenk),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () => _mailIleGiris(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Giriş Yap",
                                  style: Sabitler.butonYaziStyleKapali,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Sabitler.ikinciRenk),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () => _googleIleGiris(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/google_PNG19635.png",
                                  fit: BoxFit.fitHeight,
                                  height: 40,
                                ),
                                Expanded(
                                  child: Text(
                                    "Google ile Giriş",
                                    style: Sabitler.yaziMorStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Henüz bir hesabınız yok mu?",
                              style: Sabitler.yaziMorStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: GestureDetector(
                                child: Text(
                                  "Üye Olun",
                                  style: Sabitler.yaziSariStyle.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Sabitler.sariRenk,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  TextFormField formAlaniSifre(TextInputType keyboardType, IconData icon,
      String labelText, String hintText, deger, void Function(String?) onSaved,
      {bool yaziGizleme = false, var sifreDurumu}) {
    return TextFormField(
      obscureText: yaziGizleme,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(yaziGizleme ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _sifreGizli = !_sifreGizli;
            });
          },
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value!.length < 6) {
          return "Şifre en az 6 karakter olmalı";
        } else {
          return null;
        }
      },
    );
  }
}
