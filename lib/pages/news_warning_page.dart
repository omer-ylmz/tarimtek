// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';


class NewsWarningPage extends StatefulWidget {
  const NewsWarningPage({super.key});

  @override
  State<NewsWarningPage> createState() => _NewsWarningPageState();
}

class _NewsWarningPageState extends State<NewsWarningPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Haber Ve Uyarı"),
      ),
    );
  }
}
