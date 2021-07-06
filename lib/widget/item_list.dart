import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mantoo/helper/database.dart';
import 'package:mantoo/pages/edit_screen.dart';
import 'package:mantoo/res/custom_color.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final oCcy = new NumberFormat("#,##0", "id_ID");

  Future<User> _initializeFirebase() async {
    final u = FirebaseAuth.instance.currentUser;
    u!.reload();
    return u;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _initializeFirebase(),
        builder: (BuildContext context, AsyncSnapshot<User> data) {
          if (data.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: Database.readItems(uid: data.data!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var noteInfo = snapshot.data!.docs[index];
                      String docID = snapshot.data!.docs[index].id;
                      String title = noteInfo['title'];
                      int beli = noteInfo['harga_beli'];
                      int jual = noteInfo['harga_jual'];
                      String description = noteInfo['description'];

                      return Ink(
                        decoration: BoxDecoration(
                          color: CustomColors.firebaseGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditScreen(
                                uid: data.data!,
                                currentTitle: title,
                                currentBeli: beli,
                                currentJual: jual,
                                currentDescription: description,
                                documentId: docID,
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                'Rp ' + oCcy.format(jual).toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  CustomColors.firebaseOrange,
                ),
              ),
            );
          }
        });
  }
}
