import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/main.dart' as app;
import 'package:qlkcl/screens/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quarantine Ward', () {
    testWidgets("Quarantine Ward List", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);
      expect(quarantineWardList, findsWidgets);
    });

    testWidgets("Show detail quarantine ward", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);
      expect(quarantineWardList, findsWidgets);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      expect(find.text('Thông tin'), findsWidgets);
    });

    testWidgets("Update Quarantine Ward", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      final updateButton = find.byTooltip("Cập nhật");

      await tester.pumpAndSettle();
      await tester.tap(updateButton);
      await tester.pumpAndSettle();

      final confirmButton = find.byType(ElevatedButton).first;

      await tester.pumpAndSettle();

      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Thành công'), findsOneWidget);
    });

    testWidgets("Get List Buildings", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      final buildingsListButton = find.text("Xem tất cả");

      await tester.pumpAndSettle();
      await tester.tap(buildingsListButton);
      await tester.pumpAndSettle();

      final buildingList = find.byType(Card);
      expect(buildingList, findsWidgets);
    });

    testWidgets("Get List Floors", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      final buildingsListButton = find.text("Xem tất cả");

      await tester.pumpAndSettle();
      await tester.tap(buildingsListButton);
      await tester.pumpAndSettle();

      final buildingList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(buildingList.first);
      await tester.pumpAndSettle();

      final floorList = find.byType(Card);
      expect(floorList, findsWidgets);
    });

    testWidgets("Get List Rooms", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      final buildingsListButton = find.text("Xem tất cả");

      await tester.pumpAndSettle();
      await tester.tap(buildingsListButton);
      await tester.pumpAndSettle();

      final buildingList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(buildingList.first);
      await tester.pumpAndSettle();

      final floorList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(floorList.first);
      await tester.pumpAndSettle();

      final roomList = find.byType(Card);
      expect(roomList, findsWidgets);
    });

    testWidgets("Search quarantine ward", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final searchButton = find.byTooltip("Tìm kiếm");

      await tester.pumpAndSettle();
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final searchField = find.byType(TextField).first;

      await tester.pumpAndSettle();

      await tester.enterText(searchField, "ktx");
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      final quarantineWardList = find.byType(Card);
      expect(quarantineWardList, findsWidgets);
    });

    testWidgets("Show quarantine map", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final mapButton = find.byTooltip("Bản đồ");

      await tester.pumpAndSettle();
      await tester.tap(mapButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));

      await Future.delayed(const Duration(seconds: 2));

      final markerList = find.byIcon(Icons.location_on);
      expect(markerList, findsWidgets);
    });

    testWidgets("Get detail of room", (WidgetTester tester) async {
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
      state.selectTab(TabItem.quarantineWard);

      await tester.pumpAndSettle();

      final quarantineWardList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(quarantineWardList.first);
      await tester.pumpAndSettle();

      final buildingsListButton = find.text("Xem tất cả");

      await tester.pumpAndSettle();
      await tester.tap(buildingsListButton);
      await tester.pumpAndSettle();

      final buildingList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(buildingList.first);
      await tester.pumpAndSettle();

      final floorList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(floorList.first);
      await tester.pumpAndSettle();

      final roomList = find.byType(Card);

      await tester.pumpAndSettle();
      await tester.tap(roomList.first);
      await tester.pumpAndSettle();

      final room = find.text("Thông tin chi tiết phòng");
      expect(room, findsWidgets);
    });
  });
}
