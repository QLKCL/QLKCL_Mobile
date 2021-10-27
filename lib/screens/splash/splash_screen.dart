import 'package:flutter/material.dart';
import 'package:qlkcl/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.background,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Image.asset("assets/images/Logo.png"),
          ),
        ],
      ),
    );
  }
}