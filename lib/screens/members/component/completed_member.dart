import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class CompletedMember extends StatefulWidget {
  CompletedMember({Key? key}) : super(key: key);

  @override
  _CompletedMemberState createState() => _CompletedMemberState();
}

class _CompletedMemberState extends State<CompletedMember>
    with AutomaticKeepAliveClientMixin<CompletedMember> {
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
          await fetchMemberList(data: {'page': pageKey, 'status': "LEAVE"});

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
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, dynamic>(
          padding: EdgeInsets.only(bottom: 70),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text('Không có dữ liệu'),
                  ),
              firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Text('Có lỗi xảy ra'),
                  ),
              itemBuilder: (context, item, index) => MemberCard(
                    name: item['full_name'] ?? "",
                    gender: item['gender'] ?? "",
                    birthday: item['birthday'] ?? "",
                    lastTestResult: item['positive_test_now'],
                    lastTestTime: item['last_tested'],
                    healthStatus: item['health_status'],
                    isThreeLine: false,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => UpdateMember(
                                    code: item['code'],
                                  )));
                    },
                    menus: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: CustomColors.disableText,
                      ),
                      onSelected: (result) async {
                        if (result == 'update_info') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => UpdateMember(
                                        code: item['code'],
                                      )));
                        } else if (result == 'quarantine_history') {
                        } else if (result == 'vaccine_dose_history') {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => ListVaccineDose(
                                        code: item["code"],
                                      )));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('Cập nhật thông tin'),
                          value: "update_info",
                        ),
                        PopupMenuItem(
                          child: Text('Lịch sử cách ly'),
                          value: "quarantine_history",
                        ),
                        PopupMenuItem(
                          child: Text('Thông tin tiêm chủng'),
                          value: "vaccine_dose_history",
                        ),
                        PopupMenuItem(
                          child: Text('Tái cách ly'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
