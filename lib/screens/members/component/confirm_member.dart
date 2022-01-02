import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/confirm_member_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class ConfirmMember extends StatefulWidget {
  ConfirmMember(
      {Key? key,
      required this.longPressFlag,
      required this.indexList,
      required this.longPress})
      : super(key: key);
  final bool longPressFlag;
  final List<String> indexList;
  final VoidCallback longPress;

  @override
  _ConfirmMemberState createState() => _ConfirmMemberState();
}

class _ConfirmMemberState extends State<ConfirmMember>
    with AutomaticKeepAliveClientMixin<ConfirmMember> {
  late Future<dynamic> futureMemberList;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  bool get wantKeepAlive => true;

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
      final newItems =
          await fetchMemberList(data: {'page': pageKey, 'status': "WAITING"});

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
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => {
            _pagingController.refresh(),
            widget.indexList.clear(),
            widget.longPress(),
          },
        ),
        child: PagedListView<int, dynamic>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text('Không có dữ liệu'),
            ),
            itemBuilder: (context, item, index) => MemberCard(
              name: item['full_name'] ?? "",
              gender: item['gender'] ?? "",
              birthday: item['birthday'] ?? "",
              room:
                  (item['quarantine_room'] != null
                          ? "${item['quarantine_room']['name']} - "
                          : "") +
                      (item['quarantine_floor'] != null
                          ? "${item['quarantine_floor']['name']} - "
                          : "") +
                      (item['quarantine_building'] != null
                          ? "${item['quarantine_building']['name']} - "
                          : "") +
                      (item['quarantine_ward'] != null
                          ? "${item['quarantine_ward']['full_name']}"
                          : ""),
              lastTestResult: item['positive_test'],
              lastTestTime: item['last_tested'],
              healthStatus: item['health_status'],
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => ConfirmDetailMember(
                              code: item['code'],
                            )));
              },
              longPressEnabled: widget.longPressFlag,
              onLongPress: () {
                if (widget.indexList.contains(item['code'])) {
                  widget.indexList.remove(item['code']);
                } else {
                  widget.indexList.add(item['code']);
                }
                widget.longPress();
              },
              menus: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  // PopupMenuItem(child: Text('Chấp nhận')),
                  PopupMenuItem(
                    child: Text('Từ chối'),
                    onTap: () async {
                      EasyLoading.show();
                      final response =
                          await denyMember({'member_codes': item['code']});
                      if (response.success) {
                        _pagingController.refresh();
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      } else {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
