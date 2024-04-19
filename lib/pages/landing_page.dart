// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:tarimtek/model/user_model.dart';

import 'package:tarimtek/pages/home_page.dart';
import 'package:tarimtek/pages/sign_in_page.dart';
import 'package:tarimtek/services/auth_base.dart';

class LandingPage extends StatefulWidget {
  final AuthBase authService;

  const LandingPage({
    super.key,
    required this.authService,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _user = await widget.authService.currentUser();
  }

  void _updateUser(AppUser? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        authService: widget.authService,
        onSignIn: (user) {
          _updateUser(user);
        },
      );
    } else {
      return HomePage(
        authService: widget.authService,
        user: _user!,
        onSignOut: () {
          _updateUser(null);
        },
      );
    }
  }
}
