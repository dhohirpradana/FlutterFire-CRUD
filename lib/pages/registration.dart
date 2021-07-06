import 'package:flutter/material.dart';
import 'package:mantoo/helper/fire_auth.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title_p2.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitleP2(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'assets/firebase_logo.png',
                          height: 160,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Daftar',
                        style: TextStyle(
                          color: CustomColors.firebaseYellow,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        "MANTOO",
                        style: TextStyle(
                          color: CustomColors.firebaseOrange,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value!,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Masukan nama",
                            labelText: 'Nama',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value!,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Masukan email",
                            labelText: 'Email',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value!,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Masukan password",
                            labelText: 'Password',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green[700])),
                                onPressed: () async {
                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    await FireAuth.registerUsingEmailPassword(
                                        name: _nameTextController.text,
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text,
                                        context: context);
                                  }
                                },
                                child: Text(
                                  'DAFTAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
