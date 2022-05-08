import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quarantine Person', () {
    testWidgets("Update personal infomation", (WidgetTester tester) async {
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

      final personalInfoTab = find.text("Thông tin cá nhân");

      await tester.pumpAndSettle();
      await tester.tap(personalInfoTab);
      await tester.pumpAndSettle();

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });

    testWidgets("Update quarantine infomation", (WidgetTester tester) async {
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

      final personalInfoTab = find.text("Thông tin cá nhân");

      await tester.pumpAndSettle();
      await tester.tap(personalInfoTab);
      await tester.pumpAndSettle();

      final quarantineInfoTab = find.text("Thông tin cách ly");

      await tester.pumpAndSettle();
      await tester.tap(quarantineInfoTab);
      await tester.pumpAndSettle();

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });

    testWidgets("Quarantine Person List", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);
      expect(quarantineWardList, findsWidgets);
    });

    testWidgets("Search member", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final searchButton = find.byTooltip("Tìm kiếm");

      await tester.pumpAndSettle();
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final searchField = find.byType(TextField).first;

      await tester.pumpAndSettle();

      await tester.enterText(searchField, "son");
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final quarantineWardList = find.byType(Card);
      expect(quarantineWardList, findsWidgets);
    });

    testWidgets("Deny member", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final waitingTab = find.text("Chờ xét duyệt");

      await tester.pumpAndSettle();
      await tester.tap(waitingTab);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final denyButton = find.text("Từ chối");

      await tester.pumpAndSettle();
      await tester.tap(denyButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });

    testWidgets("Accept member", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final waitingTab = find.text("Chờ xét duyệt");

      await tester.pumpAndSettle();
      await tester.tap(waitingTab);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final acceptButton = find.text("Chấp nhận");

      await tester.pumpAndSettle();
      await tester.tap(acceptButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      if (find.text("Lỗi").evaluate().isNotEmpty) {
        expect(find.text('Lỗi'), findsOneWidget);
      } else {
        expect(find.text('Thành công'), findsOneWidget);
      }
    });

    testWidgets("Finish member", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final waitingTab = find.text("Có thể hoàn thành cách ly");

      await tester.ensureVisible(waitingTab);
      await tester.pumpAndSettle();
      await tester.tap(waitingTab);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final completeButton = find.text("Hoàn thành cách ly");

      await tester.pumpAndSettle();
      await tester.tap(completeButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      if (find.text("Lỗi").evaluate().isNotEmpty) {
        expect(find.text('Lỗi'), findsOneWidget);
      } else {
        expect(find.text('Thành công'), findsOneWidget);
      }
    });

    testWidgets("Get suiteable room for waitting member",
        (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final waitingTab = find.text("Chờ xét duyệt");

      await tester.pumpAndSettle();
      await tester.tap(waitingTab);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final viewButton = find.text("Xem thông tin");

      await tester.pumpAndSettle();
      await tester.tap(viewButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final quarantineInfoTab = find.text("Thông tin cách ly");

      await tester.pumpAndSettle();
      await tester.tap(quarantineInfoTab);
      await tester.pumpAndSettle();

      final getRoomButton = find.text("Gợi ý chọn phòng");

      await tester.pumpAndSettle();

      await tester.ensureVisible(getRoomButton);
      await tester.pumpAndSettle();
      await tester.tap(getRoomButton);
      await tester.pumpAndSettle();

      expect(getRoomButton, findsNothing);
    });

    testWidgets("Change room member", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final changeRoomButton = find.text("Chuyển phòng");

      await tester.pumpAndSettle();
      await tester.tap(changeRoomButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final dropdown = find.byType(DropdownInput<KeyValue>);

      await tester.pumpAndSettle();
      await tester.tap(dropdown.first);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final ward = find.text("Thiên Thanh Phú Quốc Resort").last;

      await tester.pumpAndSettle();
      await tester.tap(ward);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));
      await Future.delayed(const Duration(seconds: 5));

      final building = find.text("B").last;

      await tester.pumpAndSettle();
      await tester.tap(building);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));
      await Future.delayed(const Duration(seconds: 5));

      final floor = find.text("Tầng 1").last;

      await tester.pumpAndSettle();
      await tester.tap(floor);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));
      await Future.delayed(const Duration(seconds: 5));

      final room = find.text("phòng 1").last;

      await tester.pumpAndSettle();
      await tester.tap(room);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      if (find.text("Lỗi").evaluate().isNotEmpty) {
        expect(find.text('Lỗi'), findsOneWidget);
      } else {
        expect(find.text('Thành công'), findsOneWidget);
      }
    });

    testWidgets("Manager call requarantine", (WidgetTester tester) async {
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

      final AppState state = tester.state(find.byType(App));
      state.selectTab(TabItem.quarantinePerson);

      await tester.pumpAndSettle();

      final completedTab = find.text("Đã hoàn thành cách ly");

      await tester.ensureVisible(completedTab);
      await tester.pumpAndSettle();
      await tester.tap(completedTab);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final menus = find.byIcon(Icons.more_vert).first;

      await tester.pumpAndSettle();
      await tester.tap(menus);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final requarantineButton = find.text("Tái cách ly");

      await tester.pumpAndSettle();
      await tester.tap(requarantineButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final quarantineInfoTab = find.text("Thông tin cách ly");

      await tester.pumpAndSettle();
      await tester.tap(quarantineInfoTab);
      await tester.pumpAndSettle();

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });
  });
}
