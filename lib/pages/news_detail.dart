import 'package:flutter/material.dart';
import 'package:tarimtek/constants/text_style.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String source;
  final String image;
  final String contents;

  NewsDetailPage({
    required this.title,
    required this.date,
    required this.source,
    required this.image,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.arkaplan,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Haber Detayı',
          style: Sabitler.yaziStyleSiyah,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(image),
              SizedBox(height: 16),
              Text(
                title,
                style: Sabitler.yaziStyleSiyah,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date, style: Sabitler.yaziStyleGriAltBaslik),
                  Text(
                    source,
                    style: Sabitler.yaziStyleGriAltBaslik,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                contents,
                style: Sabitler.yaziStyleSiyahOkuma,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
