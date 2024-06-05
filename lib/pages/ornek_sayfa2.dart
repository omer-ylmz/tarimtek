import 'package:flutter/material.dart';

class OrnekSayfa2 extends StatefulWidget {
  const OrnekSayfa2({super.key});

  @override
  State<OrnekSayfa2> createState() => _OrnekSayfa1State();
}

class _OrnekSayfa1State extends State<OrnekSayfa2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ornek Sayfa 2"),
      ),
    );
  }
}
