import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class SearchQuarantine extends StatefulWidget {
  const SearchQuarantine({Key? key}) : super(key: key);

  @override
  _SearchQuarantineState createState() => _SearchQuarantineState();
}

class _SearchQuarantineState extends State<SearchQuarantine> {
  TextEditingController keySearch = TextEditingController();
  TextEditingController createAtMinController = TextEditingController();
  TextEditingController createAtMaxController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  TextEditingController mainManagerController = TextEditingController();

  List<KeyValue> cityList = [];
  List<KeyValue> managerList = [];

  bool searched = false;

  late Future<dynamic> futureQuarantineList;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    fetchCity({'country_code': 'VNM'}).then((value) => cityList = value);
    fetchNotMemberList({'role_name_list': 'MANAGER'})
        .then((value) => managerList = value);

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
      final newItems = await fetchQuarantineList(
        data: filterQuarantineDataForm(
          keySearch: keySearch.text,
          page: pageKey,
          createAtMin:
              parseDateToDateTimeWithTimeZone(createAtMinController.text),
          createAtMax:
              parseDateToDateTimeWithTimeZone(createAtMaxController.text),
          city: cityController.text,
          district: districtController.text,
          ward: wardController.text,
          mainManager: mainManagerController.text,
        ),
      );

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
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: TextField(
                maxLines: 1,
                autofocus: true,
                style: TextStyle(fontSize: 17),
                textAlignVertical: TextAlignVertical.center,
                controller: keySearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: CustomColors.secondaryText,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                      keySearch.clear();
                      setState(() {
                        searched = false;
                      });
                    },
                  ),
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (v) {
                  setState(() {
                    searched = true;
                  });
                  _pagingController.refresh();
                },
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                quarantineFilter(
                  context,
                  cityController: cityController,
                  districtController: districtController,
                  wardController: wardController,
                  mainManagerController: mainManagerController,
                  cityList: cityList,
                  managerList: managerList,
                  setState: () {
                    setState(() {
                      searched = true;
                    });
                    _pagingController.refresh();
                  },
                );
              },
              icon: Icon(Icons.filter_list_outlined),
            )
          ],
        ),
        body: searched
            ? MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: PagedListView<int, dynamic>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    animateTransitions: true,
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Text('Không có kết quả tìm kiếm'),
                    ),
                    itemBuilder: (context, item, index) => QuarantineItem(
                      id: item['id'].toString(),
                      name: item['full_name'] ?? "",
                      currentMem: item['num_current_member'],
                      manager: item['main_manager']['full_name'] ?? "",
                      address: (item['address'] != null
                              ? "${item['address']}, "
                              : "") +
                          (item['ward'] != null
                              ? "${item['ward']['name']}, "
                              : "") +
                          (item['district'] != null
                              ? "${item['district']['name']}, "
                              : "") +
                          (item['city'] != null
                              ? "${item['city']['name']}"
                              : ""),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text('Tìm kiếm khu cách ly'),
              ),
      ),
    );
  }
}
