import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';

class QuanrantineList extends StatefulWidget {
  // final data;
  QuanrantineList({Key? key}) : super(key: key);

  @override
  _QuanrantineListState createState() => _QuanrantineListState();
}

class _QuanrantineListState extends State<QuanrantineList> {
  late Future<FilterQuanrantineWard> futureQuarantineList;
  final PagingController<int, FilterQuanrantineWard> _pagingController =
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
      final newItems = await fetchQuarantineList(data: {'page': pageKey});

      final isLastPage = newItems.data.length < PAGE_SIZE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, FilterQuanrantineWard>(
        pagingController: _pagingController,
        padding: const EdgeInsets.only(bottom: 70),
        builderDelegate: PagedChildBuilderDelegate<FilterQuanrantineWard>(
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
                const Text('Không có dữ liệu'),
              ],
            ),
          ),
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: const Text('Có lỗi xảy ra'),
          ),
          itemBuilder: (context, item, index) => QuarantineItem(
            id: item.id.toString(),
            name: item.fullName,
            currentMem: item.numCurrentMember,
            manager: item.mainManager?.name,
            address: (item.address != null ? "${item.address}, " : "") +
                (item.ward != null ? "${item.ward?.name}, " : "") +
                (item.district != null ? "${item.district?.name}, " : "") +
                (item.city != null ? "${item.city?.name}, " : "") +
                (item.country != null ? "${item.country?.name}" : ""),
            image: item.image,
          ),
        ),
      ),
    );
  }
}
