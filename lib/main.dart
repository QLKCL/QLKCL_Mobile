import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/login.dart';
import 'package:qlkcl/routes.dart';
import 'package:qlkcl/screens/app.dart';
import 'package:qlkcl/screens/sign_in/sign_in_screen.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
void main() async {
  // Automatically show the notification bar when the app loads in IOS.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  await Hive.initFlutter();

  // Generate key to encrypt box to store secret informations (access token, refresh token,...)
  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }

  bool existRole = await Hive.boxExists('role');
  if (!existRole) {
    // Fetch role from server and store in Hive
  }

  bool isLoggedIn = await getLoginState();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  static const String routeName = "/init";
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        title: 'Quản lý khu cách ly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routes: routes,
        initialRoute: isLoggedIn ? App.routeName : SignIn.routeName,
        home: isLoggedIn ? App() : SignIn(),
      ),
    );
  }
}
