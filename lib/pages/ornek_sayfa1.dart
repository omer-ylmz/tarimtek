import 'package:flutter/material.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/pages/ornek_sayfa2.dart';

class OrnekSayfa1 extends StatefulWidget {
  const OrnekSayfa1({super.key});

  @override
  State<OrnekSayfa1> createState() => _OrnekSayfa1State();
}

class _OrnekSayfa1State extends State<OrnekSayfa1> {
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
                    builder: (context) => OrnekSayfa2(),
                  )),
              child: Text(
                "Çıkış",
                textAlign: TextAlign.center,
                style: Sabitler.yaziMorStyle,
              ),
            ),
          )
        ],
        title: Text("Ornek Sayfa 1"),
      ),
    );
  }
}
