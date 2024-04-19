// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field, unnecessary_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';

class SignInPage extends StatefulWidget {
  final Function(AppUser) onSignIn;
  final AuthBase authService;

  const SignInPage({
    super.key,
    required this.onSignIn,
    required this.authService,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  late FirebaseAuth auth;

  void _misafirGirisi() async {
    AppUser? user = await widget.authService.signInAnonymusly();
    widget.onSignIn(user!);
    debugPrint("Oturum açan User ID${user.userId}");
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Hoş Geldiniz",
                  textAlign: TextAlign.center,
                  style: Sabitler.baslikStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Verimli bir tarım deneyimi için biz buradayız. Giriş yapın ve tarımın büyülü dünyasına adım atın.",
                  textAlign: TextAlign.center,
                  style: Sabitler.yaziMorStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  // initialValue:
                  //     "omeryilmaz", //ilk olarak bu değer yazılı gelir, test yaparken kullanılabilir
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Arka plan rengi
                    // errorStyle: TextStyle(color: Colors.orange), //hata rengini değiştirmek istersek

                    labelText: "Email",
                    hintText: "omeryilmaz@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // onSaved: (deger) {
                  //   _username = deger!;
                  // },

                  validator: (value) {
                    //karakter sınırlamalarını kontrol etmek için kullanırız
                    if (value!.length < 4) {
                      return "Username en az 4 karakter olmalı";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Arka plan rengi
                    labelText: "Şifre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // onSaved: (deger) {
                  //   _username = deger!;
                  // },

                  validator: (value) {
                    //karakter sınırlamalarını kontrol etmek için kullanırız
                    if (value!.length < 4) {
                      return "Username en az 4 karakter olmalı";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                          activeColor: Sabitler.anaRenk,
                        ),
                        Text(
                          "Beni Hatırla",
                          style: Sabitler.digerStyle,
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: Text(
                        "Şifrenizi mi unuttunuz?",
                        style: Sabitler.yaziMorStyle,
                      ),
                      onTap: () {
                        debugPrint("tıklandı");
                      },
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Sabitler.anaRenk)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Sabitler.ikinciRenk),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Image.asset(
                            "assets/images/google_PNG19635.png",
                            fit: BoxFit.fitHeight,
                            height: 40,
                          ),
                        ),
                        Text(
                          "Google ile Giriş",
                          style: Sabitler.yaziMorStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Sabitler.ikinciRenk),
                    ),
                    onPressed: _misafirGirisi,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Misafir Giriş",
                          style: Sabitler.yaziMorStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
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
                              decorationColor: Sabitler.sariRenk),
                        ),
                        onTap: () {
                          debugPrint("tıklandı");
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
