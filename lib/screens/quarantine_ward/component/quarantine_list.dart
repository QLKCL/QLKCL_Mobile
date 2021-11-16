import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';

import './quarantine_item.dart';

class QuanrantineList extends StatefulWidget {
  // final data;
  QuanrantineList({Key? key}) : super(key: key);

  @override
  _QuanrantineListState createState() => _QuanrantineListState();
}

class _QuanrantineListState extends State<QuanrantineList> {
  late Future<dynamic> futureQuarantineList;
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
    // _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchQuarantineList(data: {'page': pageKey});

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
    //print(data);
    return RefreshIndicator(
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
          itemBuilder: (context, item, index)  =>  QuarantineItem(
            id: item['id'].toString(),
            name: item['full_name'] ?? "",
            // numberOfMem: fetchMemberInQuarantine(data: {'quarantine_ward_id': item['id'].toString()}),
            manager: item['main_manager']['full_name'] ?? "",
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'quarantine_item.dart';

// class QuarantineList extends StatelessWidget {
//   final data;

//   const QuarantineList({Key? key, this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return (data == null || data.isEmpty)
//         ? Center(
//             child: Text('Không có dữ liệu'),
//           )
//         : ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (ctx, index) {
//               return QuarantineItem(
//                   id: data[index]['id'].toString(),
//                   name: data[index]['full_name'] ?? "",
//                   manager: data[index]['main_manager']["full_name"] ?? "");
//             },
//           );
//   }
// }
