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
      colorScheme: ColorScheme.fromSwatch(accentColor: primary),
      primaryColor: primary,
      disabledColor: disableText,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        color: primary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: white,
        ),
        // textTheme: TextTheme(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: white,
      ),
      // textTheme: TextTheme(
      //   subtitle2: TextStyle(color: secondary),
      // bodyText1: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.normal,
      //     color: primaryText),
      // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      // ),
      // primaryTextTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.white, fontFamily: "Roboto")),
      // primaryIconTheme: IconThemeData(color: primaryText),

      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     primary: Colors.orange,
      //   ),
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primary,
          fixedSize: const Size(241, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: primary,
          minimumSize: const Size(32, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        color: white,
        shadowColor: shadow.withOpacity(0.2),
        elevation: 12,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        fillColor: white,
        filled: true, // dont forget this line
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: secondary,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 16),
      ),
      // Add the line below to get horizontal sliding transitions for routes.
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      tooltipTheme: TooltipThemeData(
        padding: const EdgeInsets.all(12),
        textStyle: TextStyle(
          color: white,
          fontSize: 13,
        ),
        decoration: BoxDecoration(
          color: secondaryText,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}

// Text color
final Color primaryText = HexColor("#262626");
final Color secondaryText = HexColor("#595959");
final Color disableText = HexColor("#8C8C8C");

// Status color
final Color success = HexColor("#52C41A");
final Color active = HexColor("#18A0FB");
final Color warning = HexColor("#FAAD14");
final Color error = HexColor("#FF4852");
final Color disable = HexColor("#F0F0F0");

// App color
final Color primary = HexColor("#484F8F"); // For title and button
final Color secondary = HexColor("#8792F2"); // For button and active navigation
final Color nonactive = HexColor("#ABAFD1"); // For non active tab layout
final Color white = HexColor("#FFFFFF");
final Color background = HexColor("#F0F2F5");
final Color shadow = HexColor("#22313F");

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(String hexColor) : super(_getColorFromHex(hexColor));
}
