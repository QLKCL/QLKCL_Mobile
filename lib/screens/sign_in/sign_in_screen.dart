import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/sign_in/forget_password_screen.dart';
import 'package:qlkcl/screens/sign_up/sign_up_screen.dart';
import 'package:qlkcl/theme/app_theme.dart';

class SignIn extends StatefulWidget {
  static const String routeName = "/sign_in";
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.background,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Image.asset("assets/images/sign_in.png"),
          ),
          SignForm(),
        ],
      ),
    );
  }
}

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  String? phoneError;
  String? passError;

  String? email;
  String? password;
  bool? remember = false;
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
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(16),
            child: Text(
              "Đăng nhập",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Input(
            label: "Số điện thoại",
            hint: "Nhập số điện thoại",
            type: TextInputType.number,
            required: true,
            validatorFunction: phoneValidator,
            controller: phoneController,
            error: phoneError,
          ),
          Input(
            label: "Mật khẩu",
            hint: "Nhập mật khẩu",
            obscure: true,
            required: true,
            controller: passController,
            error: passError,
            helper: "123456",
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPassword.routeName);
                  },
                  child: Text(
                    "Quên mật khẩu",
                    style: TextStyle(
                        color: CustomColors.primary,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  if (passController.text != '123456') {
                    setState(() {
                      passError = "Mật khẩu không chính xác!";
                    });
                  } else {
                    setState(() {
                      phoneError = null;
                      passError = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đăng nhập thành công!')),
                    );
                    await setLoginState(true);
                    Navigator.pushNamedAndRemoveUntil(context, App.routeName,
                    (Route<dynamic> route) => false);
                  }
                }
              },
              child: Text(
                'Đăng nhập',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SignUp.routeName);
            },
            child: Text(
              "Đăng ký cách ly",
              style: TextStyle(
                  color: CustomColors.primary,
                  decoration: TextDecoration.underline),
            ),
          )
        ],
      ),
    );
  }
}
