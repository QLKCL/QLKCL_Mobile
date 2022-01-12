import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/helper/onesignal.dart';
import 'package:qlkcl/utils/constant.dart';

class App extends StatefulWidget {
  static const String routeName = "/app";
  final int role;
  const App({Key? key, required this.role}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late int _role;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = false;

  var _currentTab = TabItem.homepage;
  final _navigatorKeys = {
    TabItem.homepage: GlobalKey<NavigatorState>(),
    TabItem.quarantine_person: GlobalKey<NavigatorState>(),
    TabItem.qr_code_scan: GlobalKey<NavigatorState>(),
    TabItem.quarantine_ward: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  void initState() {
    super.initState();
    _role = widget.role;
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.homepage) {
            // select 'main' tab
            _selectTab(TabItem.homepage);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.homepage),
          if (_role != 5) _buildOffstageNavigator(TabItem.quarantine_person),
          if (_role != 5) _buildOffstageNavigator(TabItem.quarantine_ward),
          _buildOffstageNavigator(TabItem.account),
        ]),
        bottomNavigationBar: BottomNavigation(
          role: _role,
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        role: _role,
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');

      print(
          "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: $event');

      /// Display Notification, send null to not display
      event.complete(null);

      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      print(
          "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId(OneSignalId);

    // Provide GDPR Consent
    OneSignal.shared.consentGranted(true);

    // // Some examples of how to use In App Messaging public methods with OneSignal SDK
    // oneSignalInAppMessagingTriggerExamples();

    // OneSignal.shared.disablePush(false);

    // // Some examples of how to use Outcome Events public methods with OneSignal SDK
    // oneSignalOutcomeEventsExamples();

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");

    handleSendTags("role", _role.toString());

    String code = await getCode();
    handleSetExternalUserId(code);
  }
}
