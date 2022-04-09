import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/utils/data_form.dart';

class CreatePassword extends StatefulWidget {
  static const String routeName = "/create_password";
  const CreatePassword({Key? key, required this.email, required this.otp})
      : super(key: key);
  final String email;
  final String otp;

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _formKey = GlobalKey<FormState>();
  final passController = TextEditingController();
  final secondPassController = TextEditingController();
  final quarantineWardController = TextEditingController();
  String? error;

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
                height: MediaQuery.of(context).size.height * 0.3,
                margin: const EdgeInsets.all(16),
                child: Image.asset("assets/images/otp.png"),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 450
                      ? 450
                      : MediaQuery.of(context).size.width,
                  child: Card(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Tạo mật khẩu mới",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Input(
                            label: "Mật khẩu mới",
                            hint: "Nhập mật khẩu mới",
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
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: Text(
                                'Xác nhận',
                                style: TextStyle(color: CustomColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        final CancelFunc cancel = showLoading();
        final response = await createPass(createPassDataForm(
            email: widget.email,
            otp: widget.otp,
            newPassword: passController.text,
            confirmPassword: secondPassController.text));
        cancel();
        showNotification(response);
        if (response.status == Status.success) {
          if (mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
      }
    }
  }
}
