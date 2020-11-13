import 'package:codex/widgets/wrong_number.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/palette.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/loading_widget.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<AuthenticationProvider>(builder: (context, data, _) {
      return LoadingWidget(
        isLoading: data.verifyingOtp,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.2),
                AppLogo(),
                Text(
                  "Enter Otp",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 30),
                _buildOtpField(),
                SizedBox(height: 30),
                Button(
                  lable: "Verify otp",
                  onPressed: () => _handleVerifyOtp(data),
                ),
                SizedBox(height: 20),
                WrongNumber(),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildOtpField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: PinCodeTextField(
        appContext: context,
        backgroundColor: Colors.transparent,
        length: 6,
        obscureText: false,
        showCursor: true,
        cursorColor: Colors.black,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 50,
          fieldWidth: 30,
          activeFillColor: Colors.transparent,
          selectedColor: Palette.mainColor,
          selectedFillColor: Colors.transparent,
          inactiveColor: Palette.mainColor.withOpacity(0.4),
          inactiveFillColor: Colors.transparent,
          activeColor: Palette.mainColor,
        ),
        enableActiveFill: true,
        controller: textEditingController,
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  _handleVerifyOtp(AuthenticationProvider provider) {
    if (textEditingController.text.trim().length != 0) {
      try {
        provider.verifyOtp(textEditingController.text, context);
      } catch (e) {
        kShowElertBox(context, e.message);
      }
    }
  }
}
