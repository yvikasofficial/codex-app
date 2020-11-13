import 'package:codex/config/palette.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String lable;
  final Function onPressed;
  Button({@required this.lable, this.onPressed});
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Palette.mainColor,
          boxShadow: [
            BoxShadow(
              color: Palette.mainColor.withOpacity(0.8),
              blurRadius: 15.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.lable.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
