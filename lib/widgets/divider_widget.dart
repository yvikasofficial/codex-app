import 'package:flutter/material.dart';

class OrDeviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 1,
          color: Colors.black.withOpacity(0.8),
        ),
        SizedBox(width: 10),
        Text(
          "or continue with",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 1,
          color: Colors.black.withOpacity(0.8),
        ),
      ],
    );
  }
}
