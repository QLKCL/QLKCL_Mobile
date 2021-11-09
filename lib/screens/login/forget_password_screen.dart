import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/login/otp_screen.dart';
import 'package:qlkcl/config/app_theme.dart';

class ForgetPassword extends StatefulWidget {
  static const String routeName = "/forget_password";
  ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
                child: Image.asset("assets/images/forget_password.png"),
              ),
              ForgetForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgetForm extends StatefulWidget {
  @override
  _ForgetFormState createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Quên mật khẩu",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: Text(
              "Nhập email khôi phục để đặt lại mật khẩu hoặc liên hệ người quản lý để hỗ trợ thêm.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Input(
            label: "Email",
            hint: "Nhập email",
            type: TextInputType.emailAddress,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Otp.routeName, arguments: email);
              },
              child: Text(
                'Tiếp theo',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
