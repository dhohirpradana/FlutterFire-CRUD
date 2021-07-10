import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mantoo/helper/connectivity.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

DateTime now = DateTime.now();
sendNotification(
    {required uid,
    required uName,
    required urId,
    required urName,
    required message,
    required externalId}) async {
  // var status = await OneSignal.shared.getDeviceState();
  // var playerId = status!.userId;
  final name = uName.toString().toUpperCase();

  await OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: [externalId],
      // bigPicture: 'https://picsum.photos/200',
      additionalData: {
        'uid': uid,
        'uName': uName,
        'urId': urId,
        'urName': urName,
        'externalId': externalId
      },
      content: message,
      heading: "FireMessage dari $name",
      buttons: [
        OSActionButton(text: "lihat", id: "lihat"),
        // OSActionButton(text: "test2", id: "id2")
      ]));
}

class MessageDatabase {
  static String userUid = user.uid;
  static Stream<QuerySnapshot> readUsers({required User uid}) {
    Query itemCollection = _mainCollection;
    return itemCollection.snapshots();
  }

  static Future<void> addChat({
    required String uid,
    required String uName,
    required String receiverId,
    required String urName,
    required String externalId,
    required String text,
  }) async {
    DocumentReference documentReferencer =
        _firestore.collection('chatting').doc();
    int time = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> data = <String, dynamic>{
      "sender": uid,
      "receiver": receiverId,
      "text": text,
      "time": time,
      "read": false,
    };
    await documentReferencer.set(data).whenComplete(() {
      print("Chat berhasil dikirim");
      sendNotification(
          uid: uid,
          uName: uName,
          urId: receiverId,
          urName: urName,
          externalId: externalId,
          message: text);
    }).catchError((e) {
      print(e);
    });
  }

  static Stream<QuerySnapshot> readMessage() {
    Query itemCollection = _firestore.collection('chatting').orderBy('time');
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
