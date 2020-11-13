import 'package:codex/config/palette.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatefulWidget {
  @override
  _AppLogoState createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    const double fontSize = 60;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "CODE",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Palette.mainColor,
            ),
          ),
          Text(
            "X",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
