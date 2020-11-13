import 'package:codex/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  LoadingWidget({@required this.isLoading, this.child});
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.mainColor),
          backgroundColor: Palette.mainColor.withOpacity(0.2),
          strokeWidth: 2,
        ),
      ),
      color: Colors.black,
      child: child,
    );
  }
}
