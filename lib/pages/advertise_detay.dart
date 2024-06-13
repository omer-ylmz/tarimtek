import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/pages/home_page.dart';
import 'package:tarimtek/viewmodel/ilan_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class AdversiteDetay extends StatefulWidget {
  Ilan? ilan;
  AdversiteDetay({Key? key, this.ilan}) : super(key: key);

  @override
  State<AdversiteDetay> createState() => _AdversiteDetayState();
}

class _AdversiteDetayState extends State<AdversiteDetay> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    final _ilanModel = Provider.of<IlanModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('İlan Verin'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _ilanModel.saveAdvert(widget.ilan!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('İlan başarıyla paylaşıldı!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: _userModel.user!),
                  ),
                );
              } catch (e) {
                print("hata oluştu db atarken");
              }
            },
            child: Text(
              'Yayınla',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(_userModel
                      .user!.profilURL!), // Replace with user's profile image
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userModel.user!.userName!),
                    Text(
                      _userModel.user!.email!,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'İlan Özeti',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ilan!.ilanTanimi!),
                    SizedBox(height: 20),
                    Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://static.ticimax.cloud/35637/uploads/urunresimleri/buyuk/cig-ic-findik-7dcb.jpg'),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.ilan!.isPozisyonu!),
                                  Row(
                                    children: [
                                      Text(widget.ilan!.isSuresi!),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(widget.ilan!.isUcreti! + "₺"),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${widget.ilan!.selectedIlce}, ${widget.ilan!.selectedIl}",
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Application details'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
