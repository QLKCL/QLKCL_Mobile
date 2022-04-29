import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notification', () {
    testWidgets("Notification List", (WidgetTester tester) async {
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

      final notificationButton = find.byTooltip("Thông báo");

      await tester.pumpAndSettle();
      await tester.tap(notificationButton);
      await tester.pumpAndSettle();

      final notificationList = find.byType(Card);
      expect(notificationList, findsWidgets);
    });

    testWidgets("Change notification status", (WidgetTester tester) async {
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

      final notificationButton = find.byTooltip("Thông báo");

      await tester.pumpAndSettle();
      await tester.tap(notificationButton);
      await tester.pumpAndSettle();

      final numOfIsRead = find
          .byIcon(
            Icons.done_all,
          )
          .evaluate()
          .length;

      final notificationList = find.byType(NotificationCard);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      await tester.tap(notificationList.first);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      final numOfIsRead2 = find
          .byIcon(
            Icons.done_all,
          )
          .evaluate()
          .length;

      expect((numOfIsRead - numOfIsRead2).abs(), 1);
    });
  });
}
