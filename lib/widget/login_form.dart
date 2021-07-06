// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mantoo/helper/database.dart';
// import 'package:mantoo/helper/validator.dart';
// import 'package:mantoo/pages/dashboard_screen.dart';
// import 'package:mantoo/res/custom_color.dart';

// import 'custom_form_field.dart';

// class LoginForm extends StatefulWidget {
//   final FocusNode focusNode;

//   const LoginForm({
//     Key? key,
//     required this.focusNode,
//   }) : super(key: key);
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   User? user = FirebaseAuth.instance.currentUser;
//   final _loginInFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _loginInFormKey,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 8.0,
//               right: 8.0,
//               bottom: 24.0,
//             ),
//             child: Column(
//               children: [
//                 CustomFormField(
//                   controller: _uidController,
//                   focusNode: widget.focusNode,
//                   keyboardType: TextInputType.text,
//                   inputAction: TextInputAction.done,
//                   validator: (value) => Validator.validateUserID(
//                     uid: value,
//                   ),
//                   label: 'User ID',
//                   hint: 'Enter your unique identifier',
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 0.0, right: 0.0),
//             child: Container(
//               width: double.maxFinite,
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(
//                     CustomColors.firebaseOrange,
//                   ),
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 onPressed: () {
//                   widget.focusNode.unfocus();

//                   if (_loginInFormKey.currentState!.validate()) {
//                     Database.userUid = user!.uid;

//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => DashboardScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
//                   child: Text(
//                     'LOGIN',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColors.firebaseGrey,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
