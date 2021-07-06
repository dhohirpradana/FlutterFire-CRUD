import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/connectivity.dart';
import 'package:mantoo/helper/database.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/custom_form_field.dart';

class AddItemForm extends StatefulWidget {
  final User uid;
  final FocusNode titleFocusNode;
  final FocusNode beliFocusNode;
  final FocusNode jualFocusNode;
  final FocusNode descriptionFocusNode;

  const AddItemForm({
    required this.uid,
    required this.titleFocusNode,
    required this.beliFocusNode,
    required this.jualFocusNode,
    required this.descriptionFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _beliController = TextEditingController();
  final TextEditingController _jualController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addItemFormKey,
      child: SingleChildScrollView(
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
                    'Nama barang',
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
                    focusNode: widget.beliFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Title',
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
                    focusNode: widget.jualFocusNode,
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
                    focusNode: widget.titleFocusNode,
                    keyboardType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Harga jual',
                    hint: 'Masukan harga jual',
                  ),
                  SizedBox(height: 24.0),
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

                        if (_addItemFormKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });

                          final internet = await checkConnectivity();
                          if (internet) {
                            await Database.addItem(
                              uid: widget.uid,
                              title: _titleController.text,
                              hargaBeli: int.parse(_beliController.text),
                              hargaJual: int.parse(_jualController.text),
                              description: _descriptionController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Berhasil tambah barang')));
                            setState(() {
                              _isProcessing = false;
                              _titleController.clear();
                              _beliController.clear();
                              _jualController.clear();
                              _descriptionController.clear();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('No internet connection.')));
                            setState(() {
                              _isProcessing = false;
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'TAMBAH BARANG',
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
