import 'package:flutter/material.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/creategroupscreen.dart';
import 'package:splitsmart/screens/joingroup.dart';
import 'package:splitsmart/screens/welcome_screen.dart';
import 'accountscreen.dart';
import 'friendscreen.dart';

class groupscreen extends StatefulWidget {
  static const String id = 'groupscreen';

  @override
  State<groupscreen> createState() => _groupscreenState();
}

class _groupscreenState extends State<groupscreen> {
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
          body: Column(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, creategroupscreen.id);
                  },
                  child: Text('Create a group')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, joingroup.id);
                  },
                  child: Text('Join a group')),
            ],
          )),
    );
  }
}
