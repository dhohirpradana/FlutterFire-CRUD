import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/pages/main_message.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

class FireAuth {
  static Future<void> addUser({
    required User uid,
    required String nama,
    required String email,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(uid.uid);
    int time = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> data = <String, dynamic>{
      "name": nama,
      "email": email,
      "registered_at": time,
      "onesignal_uid": ""
    };
    await documentReferencer.set(data).whenComplete(() {
      print("User berhasil ditambah");
    }).catchError((e) {
      print(e);
    });
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil register')));
      final user = userCredential.user;
      addUser(uid: user!, nama: name, email: email);
      await user.updateDisplayName(name);
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
    final onesignalUserId = status!.userId;
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signin...')));
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null && onesignalUserId != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        DocumentReference documentReferencer = _mainCollection.doc(user.uid);
        _mainCollection.doc(user.uid).get();
        Map<String, dynamic> data = <String, dynamic>{
          "onesignal_uid": onesignalUserId,
        };
        await documentReferencer.update(data).whenComplete(() {
          print("Onesignal user id has been SET");
        }).catchError((e) {
          print(e);
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainMessage(
              user: user,
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
