// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import 'package:tarimtek/model/user_model.dart';
import 'package:tarimtek/services/auth_base.dart';

class HomePage extends StatelessWidget {
  final AuthBase authService;
  final VoidCallback onSignOut;
  final AppUser user;

  const HomePage(
      {super.key,
      required this.authService,
      required this.onSignOut,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _cikisYap();
              },
              child: const Text(
                "Çıkış Yap",
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
        title: const Text("Ana Sayfa"),
      ),
      body: Center(
        child: Text("Hoşgeldiniz ${user.userId}"),
      ),
    );
  }

  Future<bool> _cikisYap() async {
    bool sonuc = await authService.signOut();
    onSignOut();
    return sonuc;
  }
}
