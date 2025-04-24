import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screen/home.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Column(
          children: [
            Text(
              auth.currentUser?.email ?? "Not signed in",
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
                });
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
