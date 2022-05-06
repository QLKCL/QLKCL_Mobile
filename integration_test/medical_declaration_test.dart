import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;
import 'package:qlkcl/screens/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Medical Declaration', () {
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

      final medicalDeclarationButton = find.text("Lịch sử khai báo y tế");

      await tester.pumpAndSettle();
      await tester.tap(medicalDeclarationButton);
      await tester.pumpAndSettle();

      final medicalDeclarationList = find.byType(Card);
      expect(medicalDeclarationList, findsWidgets);
    });

    testWidgets("Get medical declaration", (WidgetTester tester) async {
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

      final medicalDeclarationButton = find.text("Lịch sử khai báo y tế");

      await tester.pumpAndSettle();
      await tester.tap(medicalDeclarationButton);
      await tester.pumpAndSettle();

      final medicalDeclarationList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(medicalDeclarationList.first);
      await tester.pumpAndSettle();

      final medicalDeclaration = find.text("Thông tin tờ khai");
      expect(medicalDeclaration, findsOneWidget);
    });

    testWidgets("Create medical declaration", (WidgetTester tester) async {
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

      final medicalDeclarationButton = find.text("Khai báo y tế");

      await tester.pumpAndSettle();
      await tester.tap(medicalDeclarationButton);
      await tester.pumpAndSettle();

      final temprature = find.byType(Input).at(3);
      await tester.pumpAndSettle();
      await tester.enterText(temprature, "37.5");
      await tester.pump(const Duration(milliseconds: 1));

      final commitment = find.byType(CheckboxListTile).last;

      await tester.pumpAndSettle();
      await tester.ensureVisible(commitment);
      await tester.tap(commitment);
      await tester.pumpAndSettle();

      expect(
          tester.getSemantics(commitment),
          matchesSemantics(
            hasTapAction: true,
            hasCheckedState: true,
            isChecked: true,
            hasEnabledState: true,
            isEnabled: true,
            isFocusable: true,
          ));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });

    testWidgets("Create medical declaration with no commitment",
        (WidgetTester tester) async {
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

      final medicalDeclarationButton = find.text("Khai báo y tế");

      await tester.pumpAndSettle();
      await tester.tap(medicalDeclarationButton);
      await tester.pumpAndSettle();

      final temprature = find.byType(Input).at(3);
      await tester.pumpAndSettle();
      await tester.enterText(temprature, "37.5");
      await tester.pump(const Duration(milliseconds: 1));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Lỗi'), findsOneWidget);
    });
  });
}
