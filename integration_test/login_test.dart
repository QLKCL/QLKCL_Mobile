import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/main.dart' as app;
import 'package:qlkcl/screens/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login', () {
    testWidgets("Login with empty phone number and password",
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      app.main();

      // To wait for the animation to finish, we must use the pumpAndSettle() function provided by the WidgetTest.
      // pump() instructs the system to paint a new frame so that we can meet our expectations with a newly updated user interface.
      await tester.pumpAndSettle();
      final loginButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Số điện thoại không được để trống'), findsOneWidget);
      expect(find.text('Trường này là bắt buộc'), findsOneWidget);
    });

    testWidgets("Login with wrong phone number and password",
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final phoneField = find.byType(Input).first;
      final passwordField = find.byType(Input).last;
      final loginButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();
      await tester.enterText(phoneField, "9273973613");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.enterText(passwordField, "72853268");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Lỗi'), findsOneWidget);
    });

    testWidgets("Login sucessfully", (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final phoneField = find.byType(Input).first;
      final passwordField = find.byType(Input).last;
      final loginButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.enterText(phoneField, "0123456789");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.enterText(passwordField, "123456");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final bool isLoggedIn = await getLoginState();
      expect(isLoggedIn, true);
    });
  });

  group("Logout", () {
    testWidgets("Get list medical declaration", (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final phoneField = find.byType(Input).first;
      final passwordField = find.byType(Input).last;
      final loginButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.enterText(phoneField, "0987654321");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.enterText(passwordField, "123456");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.account);

      await tester.pumpAndSettle();

      final logoutButton = find.text("Đăng xuất");

      await tester.ensureVisible(logoutButton);
      await tester.pumpAndSettle();
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      final login = find.text("Đăng nhập");
      expect(login, findsNWidgets(2));
    });
  });
}
