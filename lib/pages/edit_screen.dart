import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/database.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title_p2.dart';
import 'package:mantoo/widget/edit_item_form.dart';

class EditScreen extends StatefulWidget {
  final User uid;
  final String currentTitle;
  final int currentBeli;
  final int currentJual;
  final String currentDescription;
  final String documentId;

  EditScreen({
    required this.uid,
    required this.currentTitle,
    required this.currentBeli,
    required this.currentJual,
    required this.currentDescription,
    required this.documentId,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _beliFocusNode = FocusNode();
  final FocusNode _jualFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitleP2(),
          actions: [
            _isDeleting
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[500],
                      size: 32,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isDeleting = true;
                      });

                      await Database.deleteItem(
                        uid: widget.uid,
                        docId: widget.documentId,
                      );

                      setState(() {
                        _isDeleting = false;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: EditItemForm(
              uid: widget.uid,
              documentId: widget.documentId,
              titleFocusNode: _titleFocusNode,
              beliFocusNode: _beliFocusNode,
              jualFocusNode: _jualFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
              currentTitle: widget.currentTitle,
              currentBeli: widget.currentBeli,
              currentJual: widget.currentJual,
              currentDescription: widget.currentDescription,
            ),
          ),
        ),
      ),
    );
  }
}
