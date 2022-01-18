import 'package:flutter/material.dart';
import 'package:splitsmart/others/reusable.dart';

import 'friendscreen.dart';
import 'groups_screen.dart';
import 'welcome_screen.dart';

class accountscreen extends StatelessWidget {
  static const String id = 'accountscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplitSmart'),
      ),
      body: Text('Account'),
    );
  }
}
