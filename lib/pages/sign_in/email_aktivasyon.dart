// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tarimtek/pages/sign_in/sign_in_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tarimtek/constants/text_style.dart';

class EmailAktivasyon extends StatefulWidget {
  final String email;

  const EmailAktivasyon({super.key, required this.email});

  @override
  State<EmailAktivasyon> createState() => _EmailAktivasyonState();
}

class _EmailAktivasyonState extends State<EmailAktivasyon> {
  void _launchEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      // Email uygulaması açılamıyorsa kullanıcıya bir mesaj gösterilebilir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email uygulaması açılamadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Email\'ini Kontrol Et',
              style: Sabitler.baslikStyle,
            ),
            const SizedBox(height: 20), // Boşluk eklemek için
            Text(
              "Doğrulama bağlantısını ${widget.email} email adresine gönderdik.",
              style: Sabitler.yaziMorStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Boşluk eklemek için
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Image.asset(
                "assets/images/image.png",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Sabitler.anaRenk)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "GİRİŞE GERİ DÖN",
                      style: Sabitler.butonYaziStyleKapali,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Sabitler.ikinciRenk),
                ),
                onPressed: () => _launchEmailApp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "AKTİVE ET",
                      style: Sabitler.yaziMorStyle,
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
