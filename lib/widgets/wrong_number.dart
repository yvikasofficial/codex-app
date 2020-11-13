import 'package:flutter/material.dart';

import '../config/palette.dart';

class WrongNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Change you phone number?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Get Back",
                  style: TextStyle(
                    fontSize: 18,
                    color: Palette.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
