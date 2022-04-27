import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/login/forget_password_screen.dart';
import 'package:qlkcl/screens/register/register_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    getLoginState().then((value) {
      if (value) {
        Future(() {
          Navigator.pushNamedAndRemoveUntil(
              context, App.routeName, (Route<dynamic> route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                margin: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: Image.asset("assets/images/sign_in.png"),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 450
                      ? 450
                      : MediaQuery.of(context).size.width,
                  child: Card(
                    child: LoginForm(),
                  ),
                ),
              ),
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
          const SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Đăng nhập",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Input(
            label: "Số điện thoại",
            hint: "Nhập số điện thoại",
            type: TextInputType.phone,
            prefixIcon: Icons.phone,
            required: true,
            validatorFunction: phoneValidator,
            controller: phoneController,
            autoValidate: false,
          ),
          Input(
            label: "Mật khẩu",
            hint: "Nhập mật khẩu",
            prefixIcon: Icons.lock,
            obscure: true,
            required: true,
            controller: passController,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPassword.routeName);
                  },
                  child: Text(
                    "Quên mật khẩu",
                    style: TextStyle(
                      color: primary,
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
                style: TextStyle(color: white),
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
                color: primary,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      final response = await login(loginDataForm(
          phoneNumber: phoneController.text, password: passController.text));
      cancel();
      if (response.status == Status.success) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, App.routeName, (Route<dynamic> route) => false);
        }
      } else {
        showNotification(response.message, status: Status.error);
      }
    }
  }
}
