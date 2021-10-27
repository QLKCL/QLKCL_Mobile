import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class CreatePassword extends StatefulWidget {
  static const String routeName = "/create_password";
  CreatePassword({Key? key}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
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
          CreatePasswordForm(),
        ],
      ),
    );
  }
}

class CreatePasswordForm extends StatefulWidget {
  @override
  _CreatePasswordFormState createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
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
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(
              "Tạo mật khẩu mới",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Input(
            label: "Mật khẩu mới",
            hint: "Mật khẩu mới",
            type: TextInputType.number,
          ),
          Input(
            label: "Xác nhận mật khẩu",
            hint: "Xác nhận mật khẩu",
            type: TextInputType.number,
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
