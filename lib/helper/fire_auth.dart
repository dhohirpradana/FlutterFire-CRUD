import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/pages/dashboard_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('onesignal');

class FireAuth {
  static Future<User?> signinUsingPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+62 8133 3534 3635',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return null;
  }

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
    var status = await OneSignal.shared.getDeviceState();
    String? onesignalUserId = status!.userId;
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
        Map<String, dynamic> data = <String, dynamic>{
          "email": user.email,
          "id": onesignalUserId,
        };

        DocumentReference documentReferencer = _mainCollection.doc(user.uid);
        _mainCollection
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            await documentReferencer.update(data).whenComplete(() {
              print("Onesignal player id berhasil diupdate");
            }).catchError((e) {
              print(e);
            });
          } else {
            await documentReferencer.set(data).whenComplete(() {
              print("Onesignal player id berhasil ditambah");
            }).catchError((e) {
              print(e);
            });
          }
        });
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
