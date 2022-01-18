import 'package:flutter/material.dart';

class cbutton extends StatelessWidget {
  static const String id = 'cbutton';
  final String x;
  final VoidCallback g;
  cbutton(this.x, this.g);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Color(0xFF66BB6A))),
        onPressed: g,
        padding: EdgeInsets.all(10.0),
        color: Color(0xFFC8E6C9),
        textColor: Colors.white,
        child: Text(x, style: TextStyle(color: Colors.green, fontSize: 15)),
      ),
    );
  }
}
