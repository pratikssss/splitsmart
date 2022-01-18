import 'package:flutter/material.dart';

class reusable extends StatelessWidget {
  final IconData x;
  final String y;
  final VoidCallback g;
  reusable(this.x, this.y, this.g);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: g,
      child: Column(
        children: [
          Icon(x),
          Text(y),
        ],
      ),
    );
  }
}
