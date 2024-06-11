// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class NewsWarningPage extends StatefulWidget {
  const NewsWarningPage({super.key});

  @override
  State<NewsWarningPage> createState() => _NewsWarningPageState();
}

class _NewsWarningPageState extends State<NewsWarningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Haber Ve Uyarı"),
      ),
    );
  }
}
