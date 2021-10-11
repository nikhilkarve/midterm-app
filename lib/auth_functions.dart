import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FireAuth {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  //Register: email & password
  Future<User?> registerUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'The password is weak.',
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'The email is already in use.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: "error in register",
        ),
      );
    }

    return user;
  }

  //Sign-In: email & password
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: "no user found for this email.",
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: "email and password does not match. please try again.",
          ),
        );
      }
    }

    return user;
  }

  //Sign-Out
  Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: "error in signout.",
        ),
      );
    }
  }

  //Sign-In: Google
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              FireAuth.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              FireAuth.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } on PlatformException {
          ScaffoldMessenger.of(context).showSnackBar(
            FireAuth.customSnackBar(
              content: 'Not supported on your platform',
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            FireAuth.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }
    return user;
  }

  //Sign-In: Email&Pass
  Future<User?> anonymousSignin({
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInAnonymously();
      user = userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: 'Error occurred while anonymous signin. Try again.',
        ),
      );
    }
    return user;
  }

  //Sign-In: Facebook
  Future<UserCredential> signInWithFacebook(
      {required BuildContext context}) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: 'Error while login with facebook.',
        ),
      );
      throw (e);
    }
  }
}
