import 'package:codex/config/palette.dart';
import 'package:codex/providers/authentication_provider.dart';
import 'package:codex/providers/country_picker_provider.dart';
import 'package:codex/screens/auth_screens/auth_screen.dart';
import 'package:codex/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth_screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CountryPickerProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
        title: 'codex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Palette.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Ubuntu',
        ),
        home: FutureBuilder(
            future: _handleInitlize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SplashScreen();
              return AuthValidationPage();
            }),
      ),
    );
  }

  Future<void> _handleInitlize() async {
    await Firebase.initializeApp();
    AuthenticationProvider.preferences = await SharedPreferences.getInstance();
  }
}

class AuthValidationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthenticationProvider>(context);
    if (provider.isLoggedIn()) {
      return HomeScreen();
    }
    return AuthenticationScreen();
  }
}
