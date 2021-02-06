import 'dart:io';

import 'package:carpool_app/models/user.dart';
import 'package:carpool_app/services/authenticate.dart';
import 'package:carpool_app/utilities/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:tournafest/models/user.dart';
//import 'package:tournafest/services/authenticate.dart';
//import 'package:tournafest/theme.dart';
//import 'package:tournafest/utilities/helper.dart';

import '../constants.dart' as Constants;
//import '../main.dart';
import '../theme.dart';
//import 'home.screen.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

File _image;

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String name, email, mobile, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        // ignore: deprecated_member_use
        autovalidate: _validate,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
//          height: MediaQuery.of(context).size.height - 236.0,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        validator: validateName,
                        onSaved: (String val) {
                          name = val;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: validateEmail,
                        onSaved: (String val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: validateMobile,
                        onSaved: (String val) {
                          mobile = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        controller: _passwordController,
                        validator: validatePassword,
                        onSaved: (String val) {
                          password = val;
                        },
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _sendToServer();
                        },
                        obscureText: true,
                        validator: (val) => validateConfirmPassword(
                            _passwordController.text, val),
                        onSaved: (String val) {
                          confirmPassword = val;
                        },
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: RaisedButton(
                          color: accentColor,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          splashColor: accentColor,
                          onPressed: _sendToServer,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: accentColor)),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Already a user ? ',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: blackColor,
                              ),
                            ),
                            InkWell(
                              onTap: () => pushAndRemoveUntil(
                                  context, LoginScreen(), false),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.0,
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
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Creating new account...', false);
      var profilePicUrl = '';
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        User user = User(
            email: email,
            name: name,
            phoneNumber: mobile,
            userID: result.user.uid,
            active: true,
            //settings: Settings(allowPushNotifications: true),
            profilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .document(result.user.uid)
            .setData(user.toJson());
        hideProgress();
        //MyAppState.currentUser = user;
        pushAndRemoveUntil(context, HomeScreen(), false);
      } catch (error) {
        hideProgress();
        /*(error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
            'Email already in use. Please pick another email address');*/
        print(error.toString());
      }
    } else {
      print('false');
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
}