import 'package:midterm_app_1/auth_functions.dart';
import 'package:midterm_app_1/screens/login_with_email_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:midterm_app_1/screens/dashboard.dart';
import 'package:midterm_app_1/screens/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../auth_functions.dart';

class AllLogins extends StatefulWidget {
  AllLogins({Key? key}) : super(key: key);

  @override
  _AllLoginsState createState() => _AllLoginsState();
}

class _AllLoginsState extends State<AllLogins> {
  var fireAuth = FireAuth();

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text('All Login Methods',
              style: TextStyle(fontFamily: 'Raleway-Bold', fontSize: 22)),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 20,
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // NEW REGISTRATION
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                      ),
                      label: const Text('New User Registration'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    const SizedBox(height: 25),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.black,
                      ),
                      label: const Text('Sign-In with email & password'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login()));
                      },
                    ),

                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.black,
                      ),
                      label: const Text(' Sign-Up with Google'),
                      onPressed: () async {
                        User? user =
                            await fireAuth.signInWithGoogle(context: context);

                        if (user!.uid != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashBoard(),
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.userSecret,
                        color: Colors.black,
                      ),
                      label: const Text('Anonymous Sign-In'),
                      onPressed: () async {
                        User? user =
                            await fireAuth.anonymousSignin(context: context);

                        if (user != null) {
                          // anonymous signin successfull
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashBoard(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.black,
                      ),
                      label: const Text('Sign-Up with Facebook'),
                      onPressed: () async {
                        try {
                          UserCredential? userCredential = await fireAuth
                              .signInWithFacebook(context: context);

                          if (userCredential != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const DashBoard(),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            FireAuth.customSnackBar(
                              content: "Error while login with facebook.",
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
