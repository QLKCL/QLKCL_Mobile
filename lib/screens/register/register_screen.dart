import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';

class Register extends StatefulWidget {
  static const String routeName = "/register";
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
          iconTheme: IconThemeData(
            color: CustomColors.primaryText,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Image.asset("assets/images/sign_up.png"),
              ),
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final secondPassController = TextEditingController();
  final quarantineWardController = TextEditingController(text: "1");
  String? error;

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
              "Đăng ký cách ly",
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
          Input(
            label: "Xác nhận mật khẩu",
            hint: "Xác nhận mật khẩu",
            obscure: true,
            required: true,
            controller: secondPassController,
            validatorFunction: passValidator,
            error: error,
          ),
          DropdownInput(
            label: 'Khu cách ly',
            hint: 'Chọn khu cách ly',
            itemValue: ['KTX Khu A'],
            required: true,
            selectedItem: 'KTX Khu A',
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                'Đăng ký',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    setState(() {
      error = null;
    });
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      if (passController.text != secondPassController.text) {
        setState(() {
          error = "Mật khẩu không trùng khớp";
        });
      } else {
        EasyLoading.show();
        final registerResponse = await register(registerDataForm(
            phoneController.text,
            passController.text,
            quarantineWardController.text));
        if (registerResponse.success) {
          final loginResponse = await login(
              loginDataForm(phoneController.text, passController.text));
          EasyLoading.dismiss();
          if (loginResponse.success) {
            int role = await getRole();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => App(role: role)),
                (Route<dynamic> route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loginResponse.message)),
            );
          }
        } else {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registerResponse.message)),
          );
        }
      }
    }
  }
}
