import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Forget password', () {
    testWidgets("Forgot password with empty email",
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));
      final forgetButton = find.text("Quên mật khẩu");
      await tester.pumpAndSettle();

      await tester.ensureVisible(forgetButton);
      await tester.pumpAndSettle();
      await tester.tap(forgetButton);
      await tester.pumpAndSettle();

      final sendMailButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(sendMailButton);
      await tester.pumpAndSettle();
      await tester.tap(sendMailButton);
      await tester.pumpAndSettle();

      expect(find.text('Trường này là bắt buộc'), findsOneWidget);
    });

    testWidgets("Forgot password with wrong email",
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));
      final forgetButton = find.text("Quên mật khẩu");
      await tester.pumpAndSettle();

      await tester.ensureVisible(forgetButton);
      await tester.pumpAndSettle();
      await tester.tap(forgetButton);
      await tester.pumpAndSettle();

      final emailField = find.byType(Input).first;
      await tester.enterText(emailField, "leson0310@gmail.com");
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      final sendMailButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(sendMailButton);
      await tester.pumpAndSettle();
      await tester.tap(sendMailButton);
      await tester.pumpAndSettle();

      expect(find.text('Lỗi'), findsOneWidget);
    });
  });
}
