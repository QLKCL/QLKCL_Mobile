import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/models/vaccine_dose.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class ListVaccineDose extends StatefulWidget {
  static const String routeName = "/list_vaccine_dose";
  ListVaccineDose({Key? key, this.code}) : super(key: key);
  final String? code;

  @override
  _ListVaccineDoseState createState() => _ListVaccineDoseState();
}

class _ListVaccineDoseState extends State<ListVaccineDose> {
  late Future<dynamic> futureTestList;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  late String code;

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
    code = widget.code ?? await getCode();
    try {
      final newItems = await fetchVaccineDoseList(
          data: {'page': pageKey, 'custom_user_code': code});

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
        title: Text("Lịch sử tiêm chủng"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.search),
        //     tooltip: "Tìm kiếm",
        //   ),
        // ],
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
              itemBuilder: (context, item, index) => VaccineDoseCard(
                vaccine: item["vaccine"]["name"],
                time: DateFormat("dd/MM/yyyy HH:mm:ss")
                    .format(DateTime.parse(item['injection_date']).toLocal()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
