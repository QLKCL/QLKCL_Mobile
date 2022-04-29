import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qlkcl/components/bottom_navigation.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/onesignal.dart';
import 'package:qlkcl/screens/login/login_screen.dart';
import 'package:qlkcl/screens/manager/update_manager_screen.dart';
import 'package:qlkcl/screens/splash/splash_screen.dart';
import 'package:qlkcl/utils/constant.dart';

import 'members/update_member_screen.dart';

class App extends StatefulWidget {
  static const String routeName = "/app";
  final int? role;
  const App({Key? key, this.role}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  DateTime currentBackPressTime = DateTime.now();
  int? _role;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool requireConsent = false;

  var _currentTab = TabItem.homepage;
  final _navigatorKeys = {
    TabItem.homepage: GlobalKey<NavigatorState>(),
    TabItem.quarantinePerson: GlobalKey<NavigatorState>(),
    TabItem.qrCodeScan: GlobalKey<NavigatorState>(),
    TabItem.quarantineWard: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void selectTab(TabItem tabItem) {
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

    getLoginState().then((value) {
      if (!value) {
        Future(() {
          Navigator.pushNamedAndRemoveUntil(
              context, Login.routeName, (Route<dynamic> route) => false);
        });
      } else {
        if (widget.role == null) {
          getRole().then((value) {
            if (mounted) {
              setState(() {
                _role = value;
              });
            }
          });
        } else {
          setState(() {
            _role = widget.role;
          });
        }
        setInfo().then((data) {
          if (data["custom_user"]["full_name"] == null ||
              data["custom_user"]["birthday"] == null ||
              data["custom_user"]["identity_number"] == null ||
              data["custom_user"]["city"] == null ||
              data["custom_user"]["district"] == null ||
              data["custom_user"]["ward"] == null ||
              data["custom_user"]["detail_address"] == null ||
              data["custom_user"]["full_name"] == "" ||
              data["custom_user"]["birthday"] == "" ||
              data["custom_user"]["identity_number"] == "" ||
              data["custom_user"]["detail_address"] == "") {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .pushNamed((_role == null || _role == 5)
                    ? UpdateMember.routeName
                    : UpdateManager.routeName);
          }
        });
      }
    });
    if (isAndroidPlatform() || isIOSPlatform()) {
      initPlatformState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _role == null
        ? const Splash()
        : WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
              if (isFirstRouteInCurrentTab) {
                // if not on the 'main' tab
                if (_currentTab != TabItem.homepage) {
                  // select 'main' tab
                  selectTab(TabItem.homepage);
                  // back button handled by app
                  return false;
                }
              }

              // let system handle back button if we're on the first route
              final DateTime now = DateTime.now();
              const int seconds = 2;
              if (now.difference(currentBackPressTime) >
                  const Duration(seconds: seconds)) {
                currentBackPressTime = now;
                showTextToast('Press "Back" button again to exit');
                return false;
              }
              return isFirstRouteInCurrentTab;
            },
            child: Scaffold(
              /// You can use an AppBar if you want to
              // appBar: AppBar(
              //  title: const Text('App'),
              // ),

              // The row is needed to display the current view
              body: Row(
                children: [
                  /// Pretty similar to the BottomNavigationBar!
                  if (Responsive.isDesktopLayout(context))
                    SideBar(
                      role: _role!,
                      currentTab: _currentTab,
                      onSelectTab: selectTab,
                    ),

                  /// Make it take the rest of the available width
                  Expanded(
                    child: Stack(children: <Widget>[
                      _buildOffstageNavigator(TabItem.homepage),
                      if (_role != 5)
                        _buildOffstageNavigator(TabItem.quarantinePerson),
                      if (_role != 5)
                        _buildOffstageNavigator(TabItem.quarantineWard),
                      _buildOffstageNavigator(TabItem.account),
                    ]),
                  )
                ],
              ),

              bottomNavigationBar: MediaQuery.of(context).size.height > 600
                  ? SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: !Responsive.isDesktopLayout(context)
                          ? BottomNavigation(
                              role: _role!,
                              currentTab: _currentTab,
                              onSelectTab: selectTab,
                            )
                          : Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: const Text(
                                "Copyright \u00a9 2022 Le Trung Son. All rights reserved.\nMade with \u2665", // https://unicode-table.com/en/
                                textAlign: TextAlign.center,
                              ),
                            ),
                    )
                  : const SizedBox(),
            ),
          );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        role: _role!,
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) {
      return;
    }

    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(requireConsent);

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
    await OneSignal.shared.setAppId(oneSignalId);

    // Provide GDPR Consent
    OneSignal.shared.consentGranted(true);

    // // Some examples of how to use In App Messaging public methods with OneSignal SDK
    // oneSignalInAppMessagingTriggerExamples();

    // OneSignal.shared.disablePush(false);

    // // Some examples of how to use Outcome Events public methods with OneSignal SDK
    // oneSignalOutcomeEventsExamples();

    final bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");

    handleSendTags("role", _role.toString());

    final int quarantineWardId = await getQuarantineWard();
    handleSendTags("quarantine_ward_id", quarantineWardId.toString());

    final String code = await getCode();
    handleSetExternalUserId(code);
  }
}
