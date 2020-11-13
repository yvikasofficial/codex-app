import 'package:codex/config/constants.dart';
import 'package:codex/providers/notification_proivder.dart';
import 'package:codex/screens/auth_screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../screens/auth_screens/auth_screen.dart';
import '../screens/home_screen.dart';

class AuthenticationProvider extends ChangeNotifier {
  static const CURRENT_AUTH_STATUS = "currentAuthStatus";
  static const GOOGLE_SIGN_IN = "googleSingIn";
  static const FB_SIGN_IN = "fbSignIn";
  static const PHONE_SIGN_IN = "phoneSignIn";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final NotificationProvider _notificationProvider = NotificationProvider();
  Map userProfile;
  static SharedPreferences preferences;

  isLoggedIn() {
    final authStatus = preferences.getString(CURRENT_AUTH_STATUS);
    return authStatus != null;
  }

  bool isLoading = false;
  bool verifyingOtp = false;
  String _verificcationId;

  Future<void> signInWithPhoneNumber(
      String phoneNo, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,

        //This callback is called when app has sms permissions and otp reviced to the sms associated with same mobile
        verificationCompleted: (AuthCredential authCredential) async {
          await _firebaseAuth.signInWithCredential(authCredential);
          isLoading = false;
          notifyListeners();
        },

        //This is called when user enters wrong otp
        verificationFailed: (FirebaseAuthException exception) {
          kShowElertBox(context, exception.message);
          isLoading = false;
          notifyListeners();
        },

        //This is called when code is sent successfully
        codeSent: (String verificationId, int resendToken) async {
          _verificcationId = verificationId;
          kRoute(context, OtpScreen());
          isLoading = false;
          notifyListeners();
        },
        timeout: Duration(seconds: 90),
        codeAutoRetrievalTimeout: (String string) async {
          // Navigator.pop(context);
        },
      );
    } catch (e) {
      throw Exception(e.message ?? e.toString());
    }
  }

  Future<void> verifyOtp(String otp, BuildContext context) async {
    verifyingOtp = true;
    notifyListeners();

    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: _verificcationId, smsCode: otp);
      final userCred = await _firebaseAuth.signInWithCredential(authCredential);
      if (userCred.user != null) {
        await _notificationProvider.saveUserDeviceToken(userCred.user.uid);
        preferences.setString(CURRENT_AUTH_STATUS, PHONE_SIGN_IN);
        Navigator.pop(context);
        kRouteReplace(context, HomeScreen());
      }
    } catch (e) {
      throw Exception(e.message ?? e.toString());
    }

    verifyingOtp = false;
    notifyListeners();
  }

  Future<void> logOut(context) async {
    final authStatus = preferences.getString(CURRENT_AUTH_STATUS);
    if (authStatus == PHONE_SIGN_IN) {
      await _firebaseAuth.signOut();
    } else if (authStatus == GOOGLE_SIGN_IN) {
      await _googleAuth.signOut();
    } else if (authStatus == FB_SIGN_IN) {
      await facebookLogin.logOut();
    }
    preferences.setString(CURRENT_AUTH_STATUS, null);
    kRouteReplace(context, AuthenticationScreen());
  }

  Future<void> signInWithGmail(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount acc = await _googleAuth.signIn();
      if (acc != null) {
        await _notificationProvider.saveUserDeviceToken(acc.id);
        preferences.setString(CURRENT_AUTH_STATUS, GOOGLE_SIGN_IN);
        kRouteReplace(context, HomeScreen());
      }
    } catch (e) {
      throw Exception(e.message);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithfb(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final result = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (result.status) {
      case FacebookLoginStatus.Success:
        final token = result.accessToken.token;
        final AuthCredential credential =
            FacebookAuthProvider.credential(token);
        final res = await _firebaseAuth.signInWithCredential(credential);
        if (res.user != null) {
          await _notificationProvider.saveUserDeviceToken(res.user.uid);
          preferences.setString(CURRENT_AUTH_STATUS, FB_SIGN_IN);
          kRouteReplace(context, HomeScreen());
        }
        break;

      case FacebookLoginStatus.Cancel:
        print("canclled");
        break;
      case FacebookLoginStatus.Error:
        print(result.error);
        throw Exception(result.error);
        break;
    }
    isLoading = false;
    notifyListeners();
  }
}
