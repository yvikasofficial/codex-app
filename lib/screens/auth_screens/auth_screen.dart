import 'package:codex/config/constants.dart';
import 'package:codex/providers/authentication_provider.dart';
import 'package:codex/providers/country_picker_provider.dart';
import 'package:codex/screens/auth_screens/select_country_screen.dart';
import 'package:codex/widgets/button.dart';
import 'package:codex/widgets/divider_widget.dart';
import 'package:codex/widgets/app_logo.dart';
import 'package:codex/widgets/loading_widget.dart';
import 'package:codex/widgets/social_auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<AuthenticationProvider>(builder: (context, data, _) {
      return LoadingWidget(
        isLoading: data.isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.2),
                AppLogo(),
                Text(
                  "Signin to continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 20),
                Consumer<CountryPickerProvider>(builder: (context, cData, _) {
                  return Column(
                    children: [
                      _buildInputField(context, cData),
                      SizedBox(height: 10),
                      Button(
                        lable: "Continue",
                        onPressed: () => _handleSignin(data, cData),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 40),
                OrDeviderWidget(),
                SizedBox(height: 20),
                SocialMediaIconWidget(
                  onPressedGoogleSignin: () => _handleGoogleSignIn(data),
                  onPressedFbSignIn: () => _handleFbSignIn(data),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _handleFbSignIn(AuthenticationProvider provider) async {
    try {
      await provider.signInWithfb(context);
    } catch (e) {
      kShowElertBox(context, e.message);
    }
  }

  _handleGoogleSignIn(AuthenticationProvider provider) async {
    try {
      await provider.signInWithGmail(context);
    } catch (e) {
      kShowElertBox(context, e.message);
    }
  }

  _handleSignin(AuthenticationProvider provider,
      CountryPickerProvider countryPickerProvider) {
    if (_textController.text.trim().length != 0) {
      try {
        provider.signInWithPhoneNumber(
            "+${countryPickerProvider.countryCode}${_textController.text}",
            context);
      } catch (e) {
        kShowElertBox(context, e.message);
      }
    }
  }

  _buildInputField(context, CountryPickerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => kRoute(context, SelectCountryScreen()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${provider.countryName}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.black38,
            width: double.infinity,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => kRoute(context, SelectCountryScreen()),
                  child: Text(
                    "+${provider.countryCode}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  color: Colors.black38,
                  width: 1,
                  height: 60,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Phone Number",
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
