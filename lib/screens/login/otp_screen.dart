import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/login/create_password_screen.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';

// cre: https://pub.dev/packages/pin_code_fields

class Otp extends StatefulWidget {
  static const String routeName = "/otp";
  Otp({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _formKey = GlobalKey<FormState>();
  late String otp;
  bool hasError = false;
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

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
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.all(16),
                child: Image.asset("assets/images/otp.png"),
              ),
              Column(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 70),
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
                        onCompleted: (value) {
                          setState(() {
                            otp = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            otp = value;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 4) {
                            return "Vui lòng nhập mã OTP";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
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
                              _reSend();
                            },
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      setState(
        () {
          hasError = false;
        },
      );
      EasyLoading.show();
      final response =
          await sendOtp(sendOtpDataForm(email: widget.email, otp: otp));
      EasyLoading.dismiss();
      if (response.success) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePassword(
                      email: widget.email,
                      otp: response.data,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } else {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    }
  }

  void _reSend() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final response =
          await requestOtp(requestOtpDataForm(email: widget.email));
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }
}
