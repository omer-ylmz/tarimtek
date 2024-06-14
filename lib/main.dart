import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/firebase_options.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/pages/landing/landing_page.dart';
import 'package:tarimtek/viewmodel/all_user_model.dart'; // Yeni eklediğimiz model dosyası
import 'package:tarimtek/viewmodel/ilan_model.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

void main() async {
  setupLacator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // MultiProvider kullandık çünkü birden fazla ChangeNotifierProvider kullanacağız
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider<AllUserModel>(
          create: (context) => AllUserModel(),
        ),
        ChangeNotifierProvider<IlanModel>(
          create: (context) => IlanModel(),
        ),
      ],
      child: MaterialApp(
        title: "TarımTek",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Sabitler.anaRenk),
        home: const LandingPage(),
      ),
    );
  }
}
