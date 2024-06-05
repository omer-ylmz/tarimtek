import 'package:flutter/material.dart';

class AdvertisePage extends StatelessWidget {
  const AdvertisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlan Verme"),
      ),
      body: const Center(
        child: Text("İlan Verme Sayfası"),
      ),
    );
  }
}
