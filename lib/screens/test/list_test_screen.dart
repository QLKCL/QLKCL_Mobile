import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/detail_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class ListTest extends StatefulWidget {
  static const String routeName = "/list_test";
  ListTest({Key? key}) : super(key: key);

  @override
  _ListTestState createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {
  late Future<dynamic> futureTestList;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

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
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchTestList(
          data: {'page': pageKey, 'user_code': await getCode()});

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
        title: Text("Lịch sử xét nghiệm"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, dynamic>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Text('Không có dữ liệu'),
              ),
              itemBuilder: (context, item, index) => TestCard(
                id: item['code'],
                time: DateFormat("dd/MM/yyyy hh:mm:ss")
                    .format(DateTime.parse(item['created_at'])),
                status: testValueList
                    .safeFirstWhere((result) => result.id == item['result'])!
                    .name,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTest(
                                code: item['code'],
                              )));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
