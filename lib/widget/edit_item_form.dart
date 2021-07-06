import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/connectivity.dart';
import 'package:mantoo/helper/database.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/res/custom_color.dart';

import 'custom_form_field.dart';

class EditItemForm extends StatefulWidget {
  final User uid;
  final FocusNode titleFocusNode;
  final FocusNode beliFocusNode;
  final FocusNode jualFocusNode;
  final FocusNode descriptionFocusNode;
  final String currentTitle;
  final int currentBeli;
  final int currentJual;
  final String currentDescription;
  final String documentId;

  const EditItemForm({
    required this.uid,
    required this.titleFocusNode,
    required this.beliFocusNode,
    required this.jualFocusNode,
    required this.descriptionFocusNode,
    required this.currentTitle,
    required this.currentBeli,
    required this.currentJual,
    required this.currentDescription,
    required this.documentId,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _beliController;
  late TextEditingController _jualController;

  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.currentTitle,
    );
    _beliController = TextEditingController(
      text: widget.currentBeli.toString(),
    );
    _jualController = TextEditingController(
      text: widget.currentJual.toString(),
    );

    _descriptionController = TextEditingController(
      text: widget.currentDescription,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _editItemFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0),
                  Text(
                    'Nama',
                    style: TextStyle(
                      color: CustomColors.firebaseGrey,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _titleController,
                    focusNode: widget.titleFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Nama',
                    hint: 'Masukan nama barang',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Harga Beli',
                    style: TextStyle(
                      color: CustomColors.firebaseGrey,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _beliController,
                    focusNode: widget.beliFocusNode,
                    keyboardType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Harga beli',
                    hint: 'Masukan harga beli',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Harga Jual',
                    style: TextStyle(
                      color: CustomColors.firebaseGrey,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _jualController,
                    focusNode: widget.jualFocusNode,
                    keyboardType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Harga jual',
                    hint: 'Masukan harga jual',
                  ),
                  Text(
                    'Keterangan',
                    style: TextStyle(
                      color: CustomColors.firebaseGrey,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 10,
                    isLabelEnabled: false,
                    controller: _descriptionController,
                    focusNode: widget.descriptionFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Keterangan',
                    hint: 'Masukan keterangan',
                  ),
                ],
              ),
            ),
            _isProcessing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    ),
                  )
                : Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomColors.firebaseOrange,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        widget.titleFocusNode.unfocus();
                        widget.beliFocusNode.unfocus();
                        widget.jualFocusNode.unfocus();
                        widget.descriptionFocusNode.unfocus();

                        if (_editItemFormKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });
                          final internet = await checkConnectivity();
                          if (internet) {
                            await Database.updateItem(
                              uid: widget.uid,
                              docId: widget.documentId,
                              title: _titleController.text,
                              hargaBeli: int.parse(_beliController.text),
                              hargaJual: int.parse(_jualController.text),
                              description: _descriptionController.text,
                            );
                            setState(() {
                              _isProcessing = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Berhasil update barang')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('No internet connection.')));
                            setState(() {
                              _isProcessing = false;
                            });
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'UPDATE BARANG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.firebaseGrey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
