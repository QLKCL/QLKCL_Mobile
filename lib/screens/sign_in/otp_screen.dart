import 'package:flutter/material.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class Otp extends StatefulWidget {
  static const String routeName = "/otp";
  Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
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
          OtpForm(),
        ],
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
              "Nhập mã xác thực",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(
              "Mã xác nhận đã được gửi qua email",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Input(
            label: "OTP",
            hint: "Nhập OTP",
            type: TextInputType.number,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Xác nhận OTP',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Chưa nhận được mã? Gửi lại mã",
              style: TextStyle(
                  color: CustomColors.primary,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
