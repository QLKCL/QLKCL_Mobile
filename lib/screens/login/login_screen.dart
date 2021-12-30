import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/login/forget_password_screen.dart';
import 'package:qlkcl/screens/register/register_screen.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.background,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Image.asset("assets/images/sign_in.png"),
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final phoneController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Đăng nhập",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Input(
            label: "Số điện thoại",
            hint: "Nhập số điện thoại",
            type: TextInputType.phone,
            required: true,
            validatorFunction: phoneValidator,
            controller: phoneController,
          ),
          Input(
            label: "Mật khẩu",
            hint: "Nhập mật khẩu",
            obscure: true,
            required: true,
            controller: passController,
            validatorFunction: passValidator,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
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
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                'Đăng nhập',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Register.routeName);
            },
            child: Text(
              "Đăng ký cách ly",
              style: TextStyle(
                color: CustomColors.primary,
                // decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final response = await login(loginDataForm(
          phoneNumber: phoneController.text, password: passController.text));
      EasyLoading.dismiss();
      if (response.success) {
        int role = await getRole();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => App(role: role)),
            (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }
}
