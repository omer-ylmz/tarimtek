// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_interpolation_to_compose_strings, avoid_print
import 'package:flutter/material.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/ornek_sayfa1.dart';
import 'package:tarimtek/services/firestore_db_service.dart';

class HomePage extends StatefulWidget {
  final AppUser user;
  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrnekSayfa1(),
                  )),
              child: Text(
                "Çıkış",
                textAlign: TextAlign.center,
                style: Sabitler.yaziMorStyle,
              ),
            ),
          )
        ],
        title: const Text("Ana Sayfa"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              AppUser? deneme =
                  await _firestoreDBService.readUser(widget.user.userId);
              print("user id" + widget.user.userId);
              print("dbden gelen" + deneme.toString());
            },
            child: const Text("get data")),
      ),
    );
  }
}
