import 'package:flutter/material.dart';
import 'package:tarimtek/constants/haber_ve_uyari.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/pages/news_detail.dart';

class NewsWarningPage extends StatefulWidget {
  @override
  State<NewsWarningPage> createState() => _NewsWarningPageState();
}

class _NewsWarningPageState extends State<NewsWarningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.arkaplan,
        title:
            Center(child: Text('TarimTek', style: Sabitler.baslikStyleKucuk)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: HaberUyariFiyat.hazelnutPrices.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              HaberUyariFiyat.hazelnutPrices[index]["name"]!,
                              style: Sabitler.yaziStyleSiyahBaslik,
                            ),
                            SizedBox(height: 2),
                            Text(
                              HaberUyariFiyat.hazelnutPrices[index]["price"]!,
                              style: Sabitler.yaziStyleSiyahBaslik,
                            ),
                            SizedBox(height: 2),
                            Text(
                              HaberUyariFiyat.hazelnutPrices[index]
                                  ["location"]!,
                              style: Sabitler.yaziStyleSiyahAltBaslik,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Haberler",
                style: Sabitler.yaziStyleSiyahBaslik,
              ),
              SizedBox(height: 5),
              Container(
                height: 250,
                child: PageView.builder(
                  itemCount: HaberUyariFiyat.news.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => NewsDetailPage(
                              title: HaberUyariFiyat.news[index]['title']!,
                              date: HaberUyariFiyat.news[index]['date']!,
                              source: HaberUyariFiyat.news[index]['source']!,
                              image: HaberUyariFiyat.news[index]['image']!,
                              contents: HaberUyariFiyat.news[index]
                                  ['contents']!,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: AspectRatio(
                                    aspectRatio: 10 / 4,
                                    child: Image.network(
                                      HaberUyariFiyat.news[index]['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${HaberUyariFiyat.news[index]['title']}",
                                    style: Sabitler.yaziStyleSiyahBaslik,
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${HaberUyariFiyat.news[index]['date']}",
                                        style: Sabitler.yaziStyleSiyahBaslik,
                                      ),
                                      Text(
                                        "${HaberUyariFiyat.news[index]['source']}",
                                        style: Sabitler.yaziStyleSiyahBaslik,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Uyarılar",
                style: Sabitler.yaziStyleSiyahBaslik,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: HaberUyariFiyat.warnings.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Uyarı resmi
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    HaberUyariFiyat.warnings[index]["image"]!),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Uyarı metni
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  HaberUyariFiyat.warnings[index]["contents"]!,
                                  style: Sabitler.yaziStyleSiyahOkuma,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "*" +
                                      HaberUyariFiyat.warnings[index]
                                          ["source"]!,
                                  style: Sabitler.yaziStyleSiyahOkuma,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
