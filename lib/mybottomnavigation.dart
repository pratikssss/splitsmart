import 'package:flutter/material.dart';
import 'package:splitsmart/screens/accountscreen.dart';
import 'package:splitsmart/screens/friendscreen.dart';
import 'package:splitsmart/screens/groups_screen.dart';

class Mybottomnavigationbar extends StatefulWidget {
  static const String id = 'navi';
  String mail;
  Mybottomnavigationbar(this.mail);
  @override
  _MybottomnavigationbarState createState() =>
      _MybottomnavigationbarState(this.mail);
}

class _MybottomnavigationbarState extends State<Mybottomnavigationbar> {
  _MybottomnavigationbarState(this.mail);
  String mail;
  int _currentindex = 0;
  final List<Widget> _children = [
    groupscreen(),
    friendscreen(),
    accountscreen(),
  ];
  void ontappedbar(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: ontappedbar,
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.groups), title: new Text('Groups')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_box), title: new Text('Friends')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_balance_outlined),
              title: new Text('Account')),
        ],
      ),
    );
  }
}
