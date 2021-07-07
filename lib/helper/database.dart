import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static Stream<QuerySnapshot> readItems({required User uid}) {
    Query itemCollection = _mainCollection
        .doc(uid.uid)
        .collection('barangs')
        .orderBy('title', descending: false);
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
