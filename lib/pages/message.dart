import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final data;
  const MessageScreen({Key? key, this.data}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MessageScreen;
    return Container(
      child: Center(
        child: Text(args.data),
      ),
    );
  }
}
