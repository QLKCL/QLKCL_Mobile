import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/screens/notification/list_notification_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/models/notification.dart' as notifications;
import 'package:qlkcl/utils/constant.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int? role;
  const HomeAppBar({Key? key, this.role}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _HomeAppBarState extends State<HomeAppBar> {
  late int unreadNotifications = 0;
  late dynamic listNotification = [];
  @override
  void initState() {
    super.initState();
    notifications.fetchUserNotificationList(
        data: {'page_size': pageSizeMax}).then((value) {
      if (mounted) {
        setState(() {
          listNotification = value;
          unreadNotifications = listNotification
              .where((element) =>
                  notifications.Notification.fromJson(element).isRead == false)
              .toList()
              .length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72), // here the desired height
      child: AppBar(
        toolbarHeight: 64, // Set this height
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        cloudinary.getImage('Default/no_avatar').toString()),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: secondary,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Xin chào,",
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    FutureBuilder(
                      future: getName(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryText),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        titleTextStyle: TextStyle(fontSize: 16, color: primaryText),
        backgroundColor: background,
        centerTitle: false,
        actions: [
          Badge(
            showBadge: unreadNotifications != 0,
            position: BadgePosition.topEnd(top: 10, end: 16),
            animationDuration: const Duration(milliseconds: 300),
            animationType: BadgeAnimationType.scale,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            badgeContent: Text(
              unreadNotifications.toString(),
              style: TextStyle(fontSize: 11, color: white),
            ),
            child: IconButton(
              padding: const EdgeInsets.only(right: 24),
              icon: Icon(
                Icons.notifications_none_outlined,
                color: primaryText,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => ListNotification(
                              role: widget.role,
                            )))
                    .then((value) => {
                          notifications.fetchUserNotificationList(data: {
                            'page_size': pageSizeMax
                          }).then((value) => setState(() {
                                listNotification = value;
                                unreadNotifications = listNotification
                                    .where((element) =>
                                        notifications.Notification.fromJson(
                                                element)
                                            .isRead ==
                                        false)
                                    .toList()
                                    .length;
                              }))
                        });
              },
              tooltip: "Thông báo",
            ),
          ),
        ],
      ),
    );
  }
}
