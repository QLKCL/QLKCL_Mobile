import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class TestMember extends StatefulWidget {
  TestMember({Key? key}) : super(key: key);

  @override
  _TestMemberState createState() => _TestMemberState();
}

class _TestMemberState extends State<TestMember>
    with AutomaticKeepAliveClientMixin<TestMember> {
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
      final newItems = await fetchMemberList(
          data: {'page': pageKey, 'is_last_tested': true});

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
              lastTestResult: item['positive_test_now'],
              lastTestTime: item['last_tested'],
              healthStatus: item['health_status'],
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => UpdateMember(
                              code: item['code'],
                            )));
              },
              menus: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (result) async {
                  if (result == 'update_info') {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => UpdateMember(
                                  code: item['code'],
                                )));
                  } else if (result == 'medical_declare_history') {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => ListMedicalDeclaration(
                                  code: item['code'],
                                  phone: item["phone_number"],
                                )));
                  } else if (result == 'create_test') {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => AddTest(
                                  code: item["code"],
                                  name: item['full_name'],
                                )))
                        .then(
                          (value) => _pagingController.refresh(),
                        );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Cập nhật thông tin'),
                    value: "update_info",
                  ),
                  PopupMenuItem(
                    child: Text('Lịch sử khai báo y tế'),
                    value: "medical_declare_history",
                  ),
                  PopupMenuItem(
                    child: Text('Tạo phiếu xét nghiệm'),
                    value: "create_test",
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
