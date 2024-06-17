import 'package:appignment_app/views/screens/auth/signin_screen.dart';
import 'package:appignment_app/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signup(String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful")),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "email-already-in-use") {
        message = "Email is already used";
      } else if (e.code == "weak-password") {
        message = "Wrong password";
      } else {
        message = "Please try again";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  static signin(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signin successful")),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "user-not-found") {
        message = "invalid email";
      } else if (e.code == "wrong-password") {
        message = "Wrong password";
      } else {
        message = "Please try again";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  static signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SigninScreen(),
          ),
        );
      },
    );
  }
}
