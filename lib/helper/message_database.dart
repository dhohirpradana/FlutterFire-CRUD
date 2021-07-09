import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:mantoo/helper/connectivity.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('onesignal');

DateTime now = DateTime.now();
sendNotification({required nama, required message, required receiver}) async {
  // var status = await OneSignal.shared.getDeviceState();
  // var playerId = status!.userId;
  final name = nama.toString().toUpperCase();

  await OneSignal.shared.postNotification(OSCreateNotification(
    playerIds: [receiver!],
    bigPicture: 'https://picsum.photos/200',
    content: message,
    heading: "FireMessage dari $name",
    // buttons: [
    //   OSActionButton(text: "OK", id: "ok"),
    //   // OSActionButton(text: "test2", id: "id2")
    // ]
  ));
}

class MessageDatabase {
  static String userUid = user.uid;
  static Stream<QuerySnapshot> readUsers({required User uid}) {
    Query itemCollection = _mainCollection;
    return itemCollection.snapshots();
  }

  static Future<void> addChat({
    required User uid,
    required String receiver,
    required String receiverId,
    required String text,
  }) async {
    DocumentReference documentReferencer =
        _firestore.collection('chatting').doc();
    int time = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> data = <String, dynamic>{
      "sender": uid.uid,
      "receiver": receiverId,
      "text": text,
      "time": time,
      "read": false,
    };
    await documentReferencer.set(data).whenComplete(() {
      print("Chat berhasil dikirim");
      sendNotification(
          nama: uid.displayName, receiver: receiver, message: text);
    }).catchError((e) {
      print(e);
    });
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
