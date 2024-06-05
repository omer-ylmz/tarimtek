import 'package:flutter/material.dart';

class NewsWarningPage extends StatelessWidget {
  const NewsWarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Haber ve Uyarılar"),
      ),
      body: const Center(
        child: Text("Haberler Sayfası"),
      ),
    );
  }
}
