import 'package:carpool_app/models/user.dart';
import 'package:carpool_app/utilities/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Text(
                'Hello!',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.red,
              child: FlatButton(
                onPressed: () async {
                  showProgress(context, 'Logging you out...', false);
                  await FirebaseAuth.instance.signOut();
                  MyAppState.currentUser = User();
                  hideProgress();
                  pushAndRemoveUntil(context, LoginScreen(), false);
                },
                child: Text('LOGOUT!'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
