import 'dart:io';
import 'dart:typed_data';

import 'package:midterm_app_1/auth_functions.dart';
import 'package:midterm_app_1/screens/dashboard.dart';
import 'package:midterm_app_1/screens/login_with_email_password.dart';
import 'package:midterm_app_1/screens/splash.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MessageApp",
      theme: ThemeData(
          primarySwatch: Colors.grey,
          backgroundColor: Colors.grey,
          accentColor: Color.fromRGBO(1, 1, 1, 1),
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.grey,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: const Text('Register',
                style: TextStyle(fontFamily: 'Raleway-Bold', fontSize: 22)),
          ),
        ),
        body: const RegisterUserForm(),
      ),
    );
  }
}

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({Key? key}) : super(key: key);

  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var fireAuth = FireAuth();

  // email address, password, name, picture, bio, hometown, age.

  var _email = "";
  var _password = "";
  var _firstName = "";
  var _lastName = "";
  var _bio = "";
  var _hometown = "";
  var _age = "";

  var isImageUploaded = false;
  // new code

  // create cloud storage instance
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var imageURL;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 20,
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // user display picture
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage:
                        imageURL != null ? NetworkImage(imageURL) : null,
                  ),

                  TextFormField(
                    decoration: const InputDecoration(hintText: "First Name"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _firstName = val;
                      });
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(hintText: "Last Name"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _lastName = val;
                      });
                    },
                  ),

                  // text field for email
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Email"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _email = val;
                      });
                    },
                  ),

                  // text field for password
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Password"),
                    textAlign: TextAlign.start,

                    obscureText: true,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },

                    onChanged: (val) {
                      setState(() {
                        _password = val;
                      });
                    },
                  ),

                  // text field for bio
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Bio"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Bio';
                      }
                      return null;
                    },

                    onChanged: (val) {
                      setState(() {
                        _bio = val;
                      });
                    },
                  ),

                  // text field for hometown
                  TextFormField(
                    decoration: const InputDecoration(hintText: "HomeTown"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Home Town';
                      }
                      return null;
                    },

                    onChanged: (val) {
                      setState(() {
                        _hometown = val;
                      });
                    },
                  ),

                  // text field for age
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Age"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Age';
                      }
                      return null;
                    },

                    onChanged: (val) {
                      setState(() {
                        _age = val;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  // icon button for file upload
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).backgroundColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      firebase_storage.FirebaseStorage storage =
                          firebase_storage.FirebaseStorage.instance;
                      final _picker = ImagePicker();
                      PickedFile image;
                      // generate some random number
                      Random random = Random();
                      int randomNumber = random.nextInt(100000);

                      await Permission.photos.request();
                      var permissionStatus = await Permission.photos.status;
                      if (permissionStatus.isGranted) {
                        try {
                          image = (await _picker.getImage(
                              source: ImageSource.gallery))!;
                          var file = File(image.path);

                          if (image != null) {
                            // proceed
                            var snapShot = await storage
                                .ref()
                                .child("display-pictures/$randomNumber")
                                .putFile(file);
                            var downloadURL =
                                await snapShot.ref.getDownloadURL();

                            setState(() {
                              imageURL = downloadURL;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              FireAuth.customSnackBar(
                                content: "NO Path received for image.",
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            FireAuth.customSnackBar(
                              content:
                                  "Couldn't select image from gallery. Please try again.",
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Upload Your Picture"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).backgroundColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("checking.. please wait..")),
                        );

                        // call the firebase function
                        User? user = await fireAuth.registerUsingEmailPassword(
                            email: _email,
                            password: _password,
                            context: context);

                        if (user != null) {
                          // registration successful
                          // if no error occurred
                          // finally insert data into firestore
                          // create collection instance in the code
                          CollectionReference users =
                              FirebaseFirestore.instance.collection("users");

                          users
                              .doc(user.uid)
                              .set({
                                'firstName': _firstName,
                                'lastName': _lastName,
                                'email': _email,
                                'password': _password,
                                'bio': _bio,
                                'hometown': _hometown,
                                'age': _age,
                                // 'avatar': Blob(blobData),
                                'imageURL': imageURL,
                                'createdAt': DateTime.now()
                              })
                              .then((value) => {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('Congrats!'),
                                              content: const Text(
                                                  'Your Registration is successful.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    // finally navigate after login
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const DashBoard()))
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ))
                                  })
                              .catchError((error) => {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                  const Text('Error Occurred!'),
                                              content: const Text(
                                                  'Error in saving your data to firestore. Please try again.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    // finally navigate after login
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SplashScreen()))
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ))
                                  });
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
                      "Already Registered?",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
