import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme with ChangeNotifier {
  static bool _isDarkTheme = true;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(accentColor: CustomColors.primary),
      primaryColor: CustomColors.primary,
      scaffoldBackgroundColor: CustomColors.background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        color: CustomColors.primary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: CustomColors.white,
        ),
        // textTheme: TextTheme(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.white,
      ),
      // textTheme: TextTheme(
      //   subtitle2: TextStyle(color: CustomColors.secondary),
      // bodyText1: TextStyle(
      //     fontSize: 16.0,
      //     fontWeight: FontWeight.normal,
      //     color: CustomColors.primaryText),
      // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      // ),
      // primaryTextTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.white, fontFamily: "Roboto")),
      // primaryIconTheme: IconThemeData(color: CustomColors.primaryText),

      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     primary: Colors.orange,
      //   ),
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: CustomColors.primary,
          fixedSize: const Size(241, 36),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: CustomColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        color: CustomColors.white,
        shadowColor: CustomColors.shadow.withOpacity(0.1),
        elevation: 12,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColors.secondary,
        foregroundColor: CustomColors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: CustomColors.secondary,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(fontSize: 16.0),
        unselectedLabelStyle: TextStyle(fontSize: 16.0),
      ),
      // Add the line below to get horizontal sliding transitions for routes.
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}

class CustomColors {
  // Text color
  static Color primaryText = HexColor("#262626");
  static Color secondaryText = HexColor("#595959");
  static Color disableText = HexColor("#8C8C8C");

  // Status color
  static Color success = HexColor("#52C41A");
  static Color active = HexColor("#18A0FB");
  static Color warning = HexColor("#FAAD14");
  static Color error = HexColor("#FF4852");

  // App color
  static Color primary = HexColor("#484F8F"); // For title and button
  static Color secondary =
      HexColor("#8792F2"); // For button and active navigation
  static Color nonactive = HexColor("#ABAFD1"); // For non active tab layout
  static Color white = HexColor("#FFFFFF");
  static Color background = HexColor("#F9FAFC");
  static Color shadow = HexColor("#22313F");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
