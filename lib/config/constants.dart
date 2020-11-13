import 'package:codex/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

kRoute(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageTransition(type: PageTransitionType.rightToLeft, child: screen),
  );
}

kRouteReplace(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    PageTransition(type: PageTransitionType.rightToLeft, child: screen),
  );
}

kShowElertBox(context, String message, {AlertType type, String title}) async {
  return await Alert(
    context: context,
    type: type ?? AlertType.error,
    title: title ?? "Authentication Failed",
    desc: message,
    buttons: [
      DialogButton(
        color: Palette.mainColor,
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
