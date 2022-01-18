import 'package:flutter/material.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/creategroupscreen.dart';
import 'package:splitsmart/screens/welcome_screen.dart';

import 'accountscreen.dart';
import 'friendscreen.dart';

class groupscreen extends StatelessWidget {
  static const String id = 'groupscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SplitSmart'),
        ),
        body: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, creategroupscreen.id);
            },
            child: Text('Create a group')));
  }
}
