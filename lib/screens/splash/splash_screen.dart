import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    // bool lightMode =
        // MediaQuery.of(context).platformBrightness == Brightness.light;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      // lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Center(
        // child: lightMode
        //     ? Image.asset('assets/images/Logo.png')
        //     : Image.asset('assets/images/Logo_dark.png')),
        child: CircularProgressIndicator(),
      ),
    );
  }
}