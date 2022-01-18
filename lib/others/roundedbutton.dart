import 'package:flutter/material.dart';

class roundedbutton extends StatelessWidget {
  late String texto;
  late Color x;
  late VoidCallback func;
  roundedbutton(this.texto, this.x, this.func);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: x,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: func,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            texto,
          ),
        ),
      ),
    );
  }
}
