import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/destination_history.dart';
import 'package:qlkcl/screens/destination_history/destination_history_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class ListDestinationHistory extends StatefulWidget {
  static const String routeName = "/list_destination_history";
  const ListDestinationHistory({Key? key, this.code}) : super(key: key);
  final String? code;

  @override
  _ListDestinationHistoryState createState() => _ListDestinationHistoryState();
}

class _ListDestinationHistoryState extends State<ListDestinationHistory> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);
  late String code;

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
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
    code = widget.code ?? await getCode();
    try {
      var newItems = await fetchDestiantionHistoryList(
          data: {'page': pageKey, 'user_code': code});

      var isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        var nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => DestinationHistoryScreen(
                        code: code,
                      )))
              .then(
                (value) => _pagingController.refresh(),
              );
        },
        child: const Icon(Icons.add),
        tooltip: "Thêm địa điểm",
      ),
      appBar: AppBar(
        title: const Text("Lịch sử di chuyển"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.search),
        //     tooltip: "Tìm kiếm",
        //   ),
        // ],
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
              itemBuilder: (context, item, index) => DestinationHistoryCard(
                name: item['user']['full_name'],
                time: (item['start_time'] != null
                        ? DateFormat("dd/MM/yyyy HH:mm:ss").format(
                            DateTime.parse(item['start_time']).toLocal())
                        : "") +
                    (item['end_time'] != null
                        ? " - ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(item['end_time']).toLocal())}"
                        : ""),
                address: getAddress(item),
                note: item['note'] ?? "",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
