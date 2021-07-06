import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/helper/fire_auth.dart';
import 'package:mantoo/pages/login_screen.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title_p2.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // bool _isSendingVerification = false;
  // bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _nama = _currentUser.displayName!.toUpperCase();
    final _email = _currentUser.displayName!;
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitleP2(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'APLIKASI MANAJEMEN TOKO ONLINE',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'NAMA: ' + _nama,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text(
                'EMAIL: ' + _email,
                // style: Theme.of(context).textTheme.bodyText1,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              _currentUser.emailVerified
                  ? Text(
                      'Email verified',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.green),
                    )
                  : Text(
                      'Email not verified (Tidak dapat kelola data)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red),
                    ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () async {
                  User? user = await FireAuth.refreshUser(_currentUser);
                  if (user != null) {
                    setState(() {
                      _currentUser = user;
                    });
                  }
                },
              ),
              // Add widgets for verifying email
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[700])),
                      onPressed: () async {
                        if (!_currentUser.emailVerified) {
                          await _currentUser.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Buka kotak masuk email anda untuk memverifikasi akun.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Akun anda telah terverifikasi.')));
                        }
                      },
                      child: Text(
                        'Verifikasi Email',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[700])),
                      onPressed: () async {
                        FireAuth.resetPassword(_currentUser.email!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Buka kotak masuk email untuk reset password.')));
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              // and, signing out the user
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            ModalRoute.withName('/'));
                      },
                      child: Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
