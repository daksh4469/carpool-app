import 'package:carpool_app/models/user.dart';
import 'package:carpool_app/services/authenticate.dart';
import 'package:carpool_app/utilities/helper.dart';
import 'package:carpool_app/views/registerScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart' as Constants;
import '../main.dart';
import '../theme.dart';
import 'homeScreen.dart';

final _fireStoreUtils = FireStoreUtils();

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String email, password;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        // ignore: deprecated_member_use
        autovalidate: _validate,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, left: 24.0),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, right: 24.0, left: 24.0),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      controller: _emailController,
                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        hintText: 'E-mail Address',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, right: 24.0, left: 24.0),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: validatePassword,
                      onSaved: (String val) {
                        password = val;
                      },
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18.0),
                      cursorColor: primaryColor,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: primaryColor,
                          ),
                          onPressed: () => _toggle(),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: RaisedButton(
                        color: accentColor,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        textColor: Colors.white,
                        splashColor: primaryColor,
                        onPressed: () async {
                          await onClick(
                              _emailController.text, _passwordController.text);
                        },
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: accentColor)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'New to Carpool ? ',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: blackColor,
                            ),
                          ),
                          InkWell(
                            onTap: () => push(context, RegisterScreen()),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onClick(String email, String password) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      User user =
      await loginWithUserNameAndPassword(email.trim(), password.trim());
      if (user != null) pushAndRemoveUntil(context, HomeScreen(), false);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Future<User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .document(result.user.uid)
          .get();
      User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data);
        user.active = true;
        await _fireStoreUtils.updateCurrentUser(user, context);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } catch (exception) {
      hideProgress();
      switch ((exception as PlatformException).code) {
        case 'ERROR_INVALID_EMAIL':
          showAlertDialog(context, 'Error', 'Email address is malformed.');
          break;
        case 'ERROR_WRONG_PASSWORD':
          showAlertDialog(context, 'Error',
              'Password does not match. Please type in the correct password.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          showAlertDialog(context, 'Error',
              'No user corresponding to the given email address. Please register first.');
          break;
        case 'ERROR_USER_DISABLED':
          showAlertDialog(context, 'Error', 'This user has been disabled');
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showAlertDialog(context, 'Error',
              'There were too many attempts to sign in as this user.');
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showAlertDialog(
              context, 'Error', 'Email & Password accounts are not enabled');
          break;
      }
      print(exception.toString());
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
