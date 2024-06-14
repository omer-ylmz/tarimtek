// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/pages/landing/landing_page.dart';
import 'package:tarimtek/viewmodel/ilan_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class AdversiteDetay extends StatefulWidget {
  Ilan? ilan;
  AdversiteDetay({super.key, this.ilan});

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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('İlan Verin'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _ilanModel.saveAdvert(widget.ilan!);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('İlan başarıyla paylaşıldı!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(),
                  ),
                );
              } catch (e) {
                print("hata oluştu db atarken");
              }
            },
            child: const Text(
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userModel.user!.userName!),
                    Text(
                      _userModel.user!.email!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'İlan Özeti',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ilan!.ilanTanimi!),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://static.ticimax.cloud/35637/uploads/urunresimleri/buyuk/cig-ic-findik-7dcb.jpg'),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.ilan!.isPozisyonu!),
                                  Row(
                                    children: [
                                      Text(widget.ilan!.isSuresi!),
                                      const SizedBox(
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Application details'),
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
