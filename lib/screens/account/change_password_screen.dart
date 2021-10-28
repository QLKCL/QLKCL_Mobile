import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = "/change_password";
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.background,
        iconTheme: IconThemeData(
          color: CustomColors.primaryText,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Image.asset("assets/images/otp.png"),
          ),
          ChangePasswordForm(),
        ],
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? oldPassword;
  String? password;
  String? confirmPasswod;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: Text(
              "Đổi mật khẩu",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Input(
            label: "Mật khẩu cũ",
            hint: "Mật khẩu cũ",
            obscure: true,
          ),
          Input(
            label: "Mật khẩu mới",
            hint: "Mật khẩu mới",
            obscure: true,
          ),
          Input(
            label: "Xác nhận mật khẩu",
            hint: "Xác nhận mật khẩu",
            obscure: true,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                'Xác nhận',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
