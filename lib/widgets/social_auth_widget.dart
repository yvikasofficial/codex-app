import 'package:flutter/material.dart';

class SocialMediaIconWidget extends StatelessWidget {
  final Function onPressedGoogleSignin;
  final Function onPressedFbSignIn;

  SocialMediaIconWidget({this.onPressedFbSignIn, this.onPressedGoogleSignin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressedGoogleSignin,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 28,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset("assets/images/google.png"),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: onPressedFbSignIn,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 29,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset("assets/images/fb.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
