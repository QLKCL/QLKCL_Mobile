import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/config/loading.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/check_network.dart';
import 'package:qlkcl/config/routes.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/login/login_screen.dart';
import 'package:qlkcl/screens/splash/splash_screen.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Automatically show the notification bar when the app loads in IOS.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  await Hive.initFlutter();

  bool isLoggedIn = await getLoginState();
  int role = await getRole();
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    role: role,
  ));
  configLoading();
}

class MyApp extends StatelessWidget {
  static const String routeName = "/init";
  final bool isLoggedIn;
  final int role;
  const MyApp({Key? key, required this.isLoggedIn, required this.role})
      : super(key: key);

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
            theme: AppTheme.lightTheme,
            home: Splash(),
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            title: 'Quản lý khu cách ly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: isLoggedIn ? App(role: role) : Login(),
            routes: routes,
            initialRoute: isLoggedIn ? App.routeName : Login.routeName,
            builder: EasyLoading.init(),
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
    // await Future.delayed(const Duration(milliseconds: 100));
  }
}
