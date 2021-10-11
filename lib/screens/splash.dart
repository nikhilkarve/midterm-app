import 'package:midterm_app_1/screens/login_types.dart';
import 'package:midterm_app_1/screens/dashboard.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import 'login_types.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateHome();
    // this will run at the first time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset('assets/meghalaya.jpg')));
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return const DashBoard();
                } else {
                  return AllLogins();
                }
              }),
        ));
  }
}
