import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/screens/accountscreen.dart';
import 'package:splitsmart/screens/friendscreen.dart';
import 'package:splitsmart/screens/groups_screen.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/loginpages/signinpage.dart';

import '../others/cbutton.dart';

class welcomescreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<welcomescreen> createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplitSmart'),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Container(
              child: Image(
                image: AssetImage('android/images/money.jpg'),
              ),
            ),
            cbutton('Login', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext) {
                return loginpage();
              }));
            }),
            cbutton('Register', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext) {
                return signinpage();
              }));
            }),
          ],
        ),
      )),
    );
  }
}
