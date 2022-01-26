import 'package:flutter/material.dart';

class buttonn extends StatelessWidget {
  String tt;
  late VoidCallback func;
  buttonn(this.tt, this.func);
  static const String id = 'buttonn';
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: func,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffB2DFDB), Color(0xff80CBC4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            tt,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
