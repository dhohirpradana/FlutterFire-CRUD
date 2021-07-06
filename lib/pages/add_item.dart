import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/add_item_form.dart';
import 'package:mantoo/widget/app_bar_title.dart';

class AddItem extends StatelessWidget {
  final User uid;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _beliFocusNode = FocusNode();
  final FocusNode _jualFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  AddItem({Key? key, required this.uid}) : super(key: key);

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
          title: AppBarTitle(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: AddItemForm(
              uid: uid,
              titleFocusNode: _titleFocusNode,
              beliFocusNode: _beliFocusNode,
              jualFocusNode: _jualFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
            ),
          ),
        ),
      ),
    );
  }
}
