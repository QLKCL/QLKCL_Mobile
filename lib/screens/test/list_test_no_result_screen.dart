import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/search_test.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class ListTestNoResult extends StatefulWidget {
  static const String routeName = "/list_test_no_result";
  const ListTestNoResult({Key? key}) : super(key: key);

  @override
  _ListTestNoResultState createState() => _ListTestNoResultState();
}

class _ListTestNoResultState extends State<ListTestNoResult> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Có lỗi xảy ra!',
            ),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: _pagingController.retryLastFailedRequest,
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
          await fetchTestList(data: {'page': pageKey, 'status': 'WAITING'});

      final isLastPage = newItems.length < pageSize;
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
        title: const Text("Xét nghiệm cần cập nhật"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context,
                      rootNavigator: !Responsive.isDesktopLayout(context))
                  .push(MaterialPageRoute(builder: (context) => SearchTest()));
            },
            icon: const Icon(Icons.search),
            tooltip: "Tìm kiếm",
          ),
        ],
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          onRefresh: () => Future.sync(_pagingController.refresh),
          child: PagedListView<int, dynamic>(
            padding: const EdgeInsets.only(bottom: 16),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Image.asset("assets/images/no_data.png"),
                    ),
                    const Text('Không có dữ liệu'),
                  ],
                ),
              ),
              firstPageErrorIndicatorBuilder: (context) => Center(
                child: const Text('Có lỗi xảy ra'),
              ),
              itemBuilder: (context, item, index) => TestNoResultCard(
                name: item['user'] != null ? item['user']['full_name'] : "",
                gender: item['user'] != null ? item['user']['gender'] : "",
                birthday:
                    item['user'] != null ? item['user']['birthday'] ?? "" : "",
                code: item['code'],
                time: item['created_at'],
                healthStatus: item['user'] != null
                    ? item['user']['health_status'] ?? ""
                    : "",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateTest(
                                code: item['code'],
                              ))).then(
                    (value) => _pagingController.refresh(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
