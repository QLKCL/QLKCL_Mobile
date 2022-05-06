import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;
import 'package:qlkcl/screens/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test', () {
    // testWidgets("Get list test", (WidgetTester tester) async {
    //   app.main();

    //   await tester.pumpAndSettle();
    //   await tester.pump(const Duration(milliseconds: 1));

    //   final phoneField = find.byType(Input).first;
    //   final passwordField = find.byType(Input).last;
    //   final loginButton = find.byType(ElevatedButton).first;

    //   await tester.pumpAndSettle();

    //   await tester.enterText(phoneField, "0987654321");
    //   await tester.pump(const Duration(milliseconds: 1));
    //   await tester.enterText(passwordField, "123456");
    //   await tester.pump(const Duration(milliseconds: 1));
    //   await tester.pumpAndSettle();

    //   await tester.ensureVisible(loginButton);
    //   await tester.pumpAndSettle();
    //   await tester.tap(loginButton);
    //   await tester.pumpAndSettle();

    //   final AppState state = tester.state(find.byType(App));
    //   state.selectTab(TabItem.account);

    //   await tester.pumpAndSettle();

    //   final testButton = find.text("Kết quả xét nghiệm");

    //   await tester.pumpAndSettle();
    //   await tester.tap(testButton);
    //   await tester.pumpAndSettle();

    //   final testList = find.byType(Card);
    //   expect(testList, findsWidgets);
    // });

    testWidgets("Get Test", (WidgetTester tester) async {
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

      final testButton = find.text("Kết quả xét nghiệm");

      await tester.pumpAndSettle();
      await tester.tap(testButton);
      await tester.pumpAndSettle();

      final testList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(testList.first);
      await tester.pumpAndSettle();

      final test = find.text("Thông tin phiếu xét nghiệm");
      expect(test, findsOneWidget);
    });
  });
}
