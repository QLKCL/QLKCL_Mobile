import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/notification.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/notification/create_notification_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class ListNotification extends StatefulWidget {
  static const String routeName = "/list_notification";
  ListNotification({Key? key, this.role = 5}) : super(key: key);
  final int role;

  @override
  _ListNotificationState createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Có lỗi xảy ra!',
            ),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchUserNotificationList(data: {'page': pageKey});

      final isLastPage = newItems.length < PAGE_SIZE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông báo"),
        centerTitle: true,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.only(bottom: 16),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Image.asset("assets/images/no_data.png"),
                    ),
                    Text('Không có dữ liệu'),
                  ],
                ),
              ),
              firstPageErrorIndicatorBuilder: (context) => Center(
                child: Text('Có lỗi xảy ra'),
              ),
              itemBuilder: (context, item, index) => NotificationCard(
                title: item['notification']['title'],
                description: item['notification']['description'],
                time: DateFormat("dd/MM/yyyy HH:mm:ss").format(
                    DateTime.parse(item['notification']['created_at'])
                        .toLocal()),
                status: item['is_read'],
                image: item['notification']['image'],
                url: item['notification']['url'],
                onTap: () async {
                  final response = await changeStateUserNotification(
                      data: {'notification': item['notification']['id']});
                  if (response.status == Status.success) {
                    setState(() {
                      item['is_read'] = response.data;
                    });
                    // _pagingController.refresh();
                  }
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: widget.role != 5
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context,
                        rootNavigator: !Responsive.isDesktopLayout(context))
                    .push(MaterialPageRoute(
                        builder: (context) => CreateNotification()));
              },
              child: Icon(Icons.add),
              tooltip: "Tạo thông báo",
            )
          : null,
    );
  }
}
