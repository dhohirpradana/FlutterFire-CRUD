import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/connectivity.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('mantoo');

class Database {
  static String userUid = user.uid;
  static Future<void> addItem({
    required User uid,
    required String title,
    required int hargaBeli,
    required int hargaJual,
    required String description,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(uid.uid).collection('barangs').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "harga_beli": hargaBeli,
      "harga_jual": hargaJual,
      "description": description,
    };
    if (user.emailVerified) {
      await documentReferencer.set(data).whenComplete(() {
        print("Barang berhasil ditambah");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Barang berhasil ditambah.')));
      }).catchError((e) {
        print(e);
      });
    } else if (!user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dibutuhkan verifikasi email.')));
    }
  }

  static Future uploadImageToFirebase(
      BuildContext context, File _imageFile, String uid) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // String fileName = _imageFile.path;
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$uid-profile.jpg');
    await firebaseStorageRef.putFile(_imageFile);
    var url = await firebaseStorageRef.getDownloadURL();
    print(url);
    DocumentReference documentReferencer =
        _mainCollection.doc(uid).collection('profile').doc();
    await documentReferencer.set({'image': url, 'time': now}).whenComplete(() {
      print("Gambar berhasil diupload");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gambar berhasil diupload.')));
    }).catchError((e) {
      print(e);
    });
  }

  static Stream<QuerySnapshot> readItems({required User uid}) {
    Query itemCollection = _mainCollection
        .doc(uid.uid)
        .collection('barangs')
        .orderBy('title', descending: false);
    return itemCollection.snapshots();
  }

  static Stream<QuerySnapshot> readProfileImage({required User uid}) {
    Query itemCollection = _mainCollection
        .doc(uid.uid)
        .collection('profile')
        .orderBy('time', descending: true)
        .limit(1);
    return itemCollection.snapshots();
  }

  static Future<void> updateItem({
    required User uid,
    required String title,
    required int hargaBeli,
    required int hargaJual,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(uid.uid).collection('barangs').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "harga_beli": hargaBeli,
      "harga_jual": hargaJual,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Barang berhasil diupdate"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteItem({
    required User uid,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(uid.uid).collection('barangs').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Item deleted from the database'))
        .catchError((e) => print(e));
  }
}
