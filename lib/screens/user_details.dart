import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class UserDetails extends StatefulWidget {
  UserDetails(
      {Key? key,
      required this.imageURL,
      required this.firstName,
      required this.lastName,
      required this.bio,
      required this.hometown,
      required this.age})
      : super(key: key);

  final String imageURL;
  final String firstName;
  final String lastName;
  final String bio;
  final String hometown;
  final String age;

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text('User Details',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 22)),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 20,
            margin: const EdgeInsets.all(50),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100.0,
                    backgroundImage: widget.imageURL != null
                        ? NetworkImage(widget.imageURL)
                        : null,
                    backgroundColor: widget.imageURL == null
                        ? Colors.brown.shade800
                        : Colors.transparent,
                  ),
                  Text(
                    widget.firstName.toUpperCase() +
                        " " +
                        widget.lastName.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.age + " years old",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.bio,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: '📍', // emoji characters
                          style: TextStyle(
                            fontFamily: 'EmojiOne',
                          ),
                        ),
                        TextSpan(
                            text: widget.hometown, // non-emoji characters
                            style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
