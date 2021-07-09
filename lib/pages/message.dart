import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/message_database.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title_p2.dart';

class MessageScreen extends StatefulWidget {
  final User user;
  final String receiverId;
  final String receiver;
  const MessageScreen(
      {Key? key,
      required this.user,
      required this.receiverId,
      required this.receiver})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chatController = TextEditingController();
  final _chatNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitleP2(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _chatController,
                  focusNode: _chatNode,
                  validator: (value) => Validator.validateField(value: value!),
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
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[700])),
                          onPressed: () {
                            MessageDatabase.addChat(
                              uid: widget.user,
                              receiverId: widget.receiverId,
                              receiver: widget.receiver,
                              text: _chatController.text,
                            ).whenComplete(() => _chatController.clear());
                          },
                          child: Text('KIRIM')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
