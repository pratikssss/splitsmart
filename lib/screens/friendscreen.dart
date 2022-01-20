import 'package:flutter/material.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/welcome_screen.dart';

import 'accountscreen.dart';
import 'groups_screen.dart';

class friendscreen extends StatefulWidget {
  static const String id = 'friendscreen';

  @override
  State<friendscreen> createState() => _friendscreenState();
}

class _friendscreenState extends State<friendscreen> {
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
        body: Text('Friends'),
      ),
    );
  }
}
