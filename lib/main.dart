import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/sign_in/sign_in_screen.dart';
import 'package:qlkcl/screens/splash/splash_screen.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() {
  // Automatically show the notification bar when the app loads in IOS.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool logged = true;
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            title: 'Quản lý khu cách ly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: (logged == false) ? SignInScreen() : App(),
          );
        }
      },
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}
