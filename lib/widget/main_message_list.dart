import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/message_database.dart';
import 'package:mantoo/pages/message.dart';
import 'package:mantoo/res/custom_color.dart';

class MainMessageList extends StatefulWidget {
  final User user;
  const MainMessageList({Key? key, required this.user}) : super(key: key);

  @override
  _MainMessageListState createState() => _MainMessageListState();
}

class _MainMessageListState extends State<MainMessageList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: MessageDatabase.readUsers(uid: widget.user),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String docID = snapshot.data!.docs[index].id;
              var oneSignalUser = snapshot.data!.docs[index];
              String email = oneSignalUser['email'];
              String oneSignalId = oneSignalUser['id'];
              return Visibility(
                visible: (docID == widget.user.uid) ? false : true,
                child: Ink(
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
                        builder: (context) => MessageScreen(
                          user: user,
                          receiverId: docID,
                          receiver: oneSignalId,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
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
  }
}
