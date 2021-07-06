import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/pages/dashboard_screen.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signup...')));
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil register')));
      final user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signin...')));
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              uid: user,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
    return null;
  }

  // static signOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  // static sendEmailVerivication(User user) async {
  //   await user.sendEmailVerification();
  // }

  static Future<void> resetPassword(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}
