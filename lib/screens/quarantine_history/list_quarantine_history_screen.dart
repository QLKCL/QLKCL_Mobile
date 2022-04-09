import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/models/quarantine_history.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class ListQuarantineHistory extends StatefulWidget {
  static const String routeName = "/list_quarantine_history";
  const ListQuarantineHistory({Key? key, this.code}) : super(key: key);
  final String? code;

  @override
  _ListQuarantineHistoryState createState() => _ListQuarantineHistoryState();
}

class _ListQuarantineHistoryState extends State<ListQuarantineHistory> {
  final PagingController<int, QuarantineHistory> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);
  late String code;

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
    code = widget.code ?? await getCode();
    try {
      final newItems = await fetchQuarantineHistoryList(
          data: {'page': pageKey, 'user_code': code});

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
        title: const Text("Lịch sử cách ly"),
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
          child: PagedListView<int, QuarantineHistory>(
            padding: const EdgeInsets.only(bottom: 16),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<QuarantineHistory>(
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
              firstPageErrorIndicatorBuilder: (context) => const Center(
                child: Text('Có lỗi xảy ra'),
              ),
              itemBuilder: (context, item, index) => QuarantineHistoryCard(
                name: item.user.name,
                time: (DateFormat("dd/MM/yyyy HH:mm:ss")
                        .format(DateTime.parse(item.startDate).toLocal())) +
                    (item.endDate != null
                        ? " - ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(item.endDate).toLocal())}"
                        : " - Hiện tại"),
                room:
                    (item.quarantineRoom != null
                            ? "${item.quarantineRoom?.name}, "
                            : "") +
                        (item.quarantineFloor != null
                            ? "${item.quarantineFloor?.name}, "
                            : "") +
                        (item.quarantineBuilding != null
                            ? "${item.quarantineBuilding?.name}, "
                            : "") +
                        ("${item.quarantineWard.name}"),
                pademic: item.pandemic.name,
                note: item.note ?? "",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
