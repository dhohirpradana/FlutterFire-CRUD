import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mantoo/helper/message_database.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/appbar_title_p3.dart';

class MessageScreen extends StatefulWidget {
  final String user;
  final String name;
  final String receiverName;
  final String receiverId;
  final String externalId;
  const MessageScreen(
      {Key? key,
      required this.user,
      required this.name,
      required this.receiverName,
      required this.receiverId,
      required this.externalId})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chatController = TextEditingController();
  final _chatNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients)
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitleP3(
          nama: widget.receiverName,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder<QuerySnapshot>(
              stream: MessageDatabase.readMessage(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return ListView.separated(
                    controller: _scrollController,
                    cacheExtent: 10,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var mantooMessage = snapshot.data!.docs[index];
                      final message = mantooMessage['text'];
                      final penerima = mantooMessage['receiver'];
                      final time = mantooMessage['time'];
                      final jam = DateTime.fromMillisecondsSinceEpoch(time);
                      return (penerima == widget.user ||
                              penerima == widget.receiverId)
                          ? ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Align(
                                alignment: (penerima == widget.user)
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Bubble(
                                  color: Colors.blue,
                                  margin: BubbleEdges.only(top: 10),
                                  nip: (penerima == widget.user)
                                      ? BubbleNip.rightBottom
                                      : BubbleNip.leftBottom,
                                  child: Text(
                                    message,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                              subtitle: Align(
                                alignment: (penerima == widget.user)
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Text(
                                  jam.hour.toString() +
                                      ':' +
                                      jam.minute.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            )
                          : SizedBox();
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _chatController,
                          focusNode: _chatNode,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                              // labelText: '',
                              hintText: "Tulis pesan...",
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    MessageDatabase.addChat(
                                      uid: widget.user,
                                      uName: widget.name,
                                      receiverId: widget.receiverId,
                                      urName: widget.receiverName,
                                      externalId: widget.externalId,
                                      text: _chatController.text,
                                    ).whenComplete(() {
                                      _chatController.clear();
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((_) {
                                        if (_scrollController.hasClients)
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOut,
                                          );
                                      });
                                    });
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
