import 'package:flutter/material.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/welcome_screen.dart';

import 'accountscreen.dart';
import 'groups_screen.dart';

class friendscreen extends StatelessWidget {
  static const String id = 'friendscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplitSmart'),
      ),
      body: Text('Friends'),
    );
  }
}
