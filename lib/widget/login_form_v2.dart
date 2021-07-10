import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/fire_auth.dart';
import 'package:mantoo/helper/validator.dart';
import 'package:mantoo/pages/main_message.dart';
import 'package:mantoo/pages/registration.dart';
import 'package:mantoo/res/custom_color.dart';

class WidgetFormLogin extends StatelessWidget {
  WidgetFormLogin({Key? key}) : super(key: key);

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: _emailTextController,
            focusNode: _focusEmail,
            validator: (value) => Validator.validateEmail(email: value!),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: "Masukan email",
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
          SizedBox(height: 16.0),
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: _passwordTextController,
            focusNode: _focusPassword,
            obscureText: true,
            validator: (value) => Validator.validatePassword(password: value!),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: "Masukan password",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          CustomColors.firebaseOrange)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User? user = await FireAuth.signInUsingEmailPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                        context: context,
                      );
                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => MainMessage(
                                    user: user,
                                  )),
                        );
                      }
                    }
                  },
                  child: Text(
                    'MASUK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green[700])),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    );
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
    );
  }
}
