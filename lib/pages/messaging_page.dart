import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesajlarım"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("konusmalar")
            .where("konusma_sahibi", isEqualTo: _userModel.user!.userId)
            .orderBy("olusturulma_tarihi", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tumKonusmalar.length,
              itemBuilder: (context, index) {
                var oAnkiKonusma = tumKonusmalar[index];
                return ListTile(
                  title: Text(oAnkiKonusma["son_yollanan_mesaj"]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
