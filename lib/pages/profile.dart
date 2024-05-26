import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: () => _cikisYap(context),
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
      body: Center(
        child: Text("Profil Sayfası"),
      ),
    );
  }
}

Future<bool> _cikisYap(BuildContext context) async {
  final _userModel = Provider.of<UserModel>(context, listen: false);
  bool sonuc = await _userModel.signOut();
  return sonuc;
}
