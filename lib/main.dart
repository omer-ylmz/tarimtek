import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tarimtek/firebase_options.dart';
import 'package:tarimtek/pages/landing_page.dart';
import 'package:tarimtek/services/firebase_auth_service.dart';

void main() async {
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
    return MaterialApp(
      title: "TarımTek",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: LandingPage(
        authService: FirebaseAuthService(),
      ),
    );
  }
}
