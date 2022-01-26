import 'package:flutter/material.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/groupsowned.dart';

import 'friendscreen.dart';
import 'groups_screen.dart';
import 'welcome_screen.dart';

class accountscreen extends StatefulWidget {
  static const String id = 'accountscreen';

  @override
  State<accountscreen> createState() => _accountscreenState();
}

class _accountscreenState extends State<accountscreen> {
  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text('SplitSmart'),
          ),
          body: SafeArea(
              child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('android/images/mmoney.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: buttonn('Your details', () {
                      Navigator.pushNamed(context, groupsowned.id);
                    }),
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: buttonn('Logout', () {
                      Navigator.pushNamed(context, loginpage.id);
                    }),
                  ),
                ],
              )
            ],
          ))),
    );
  }
}
