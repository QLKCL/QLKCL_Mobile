import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/login/create_password_screen.dart';
import 'package:qlkcl/config/app_theme.dart';

// cre: https://pub.dev/packages/pin_code_fields

class Otp extends StatefulWidget {
  static const String routeName = "/otp";
  Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.background,
          iconTheme: IconThemeData(
            color: CustomColors.primaryText,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Image.asset("assets/images/otp.png"),
              ),
              OtpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? otp;
  bool hasError = false;
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "Nhập mã xác thực",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Text(
            "Mã xác nhận đã được gửi qua email",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 70),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 62,
                fieldWidth: 48,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: Duration(milliseconds: 300),
              errorAnimationController: errorController,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                // setState(() {
                //   currentText = value;
                // });
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, CreatePassword.routeName,
                  arguments: email);
            },
            child: Text(
              'Xác nhận OTP',
              style: TextStyle(color: CustomColors.white),
            ),
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Chưa nhận được mã? ",
              ),
              TextSpan(
                text: 'Gửi lại mã',
                style: TextStyle(
                    color: CustomColors.primary,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // navigate to desired screen
                    print("OTP resend tapped");
                  },
              )
            ],
          ),
        ),
      ],
    );
  }
}
