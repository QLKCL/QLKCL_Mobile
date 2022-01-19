import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class DenyMember extends StatefulWidget {
  DenyMember({Key? key}) : super(key: key);

  @override
  _DenyMemberState createState() => _DenyMemberState();
}

class _DenyMemberState extends State<DenyMember>
    with AutomaticKeepAliveClientMixin<DenyMember> {
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
          await fetchMemberList(data: {'page': pageKey, 'status': "REFUSED"});

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
              itemBuilder: (context, item, index) => MemberInRoomCard(
                    name: item['full_name'] ?? "",
                    gender: item['gender'] ?? "",
                    birthday: item['birthday'] ?? "",
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
                  )),
        ),
      ),
    );
  }
}
