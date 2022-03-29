import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SearchTest extends StatefulWidget {
  SearchTest({Key? key}) : super(key: key);

  @override
  _SearchTestState createState() => _SearchTestState();
}

class _SearchTestState extends State<SearchTest> {
  TextEditingController keySearch = TextEditingController();
  final userCodeController = TextEditingController();
  final stateController = TextEditingController();
  final typeController = TextEditingController();
  final resultController = TextEditingController();
  final createAtMinController = TextEditingController();
  final createAtMaxController = TextEditingController();

  bool searched = false;
  late Future<dynamic> futureTestList;
  final PagingController<int, dynamic> _pagingController =
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
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchTestList(
          data: filterTestDataForm(
        page: pageKey,
        status: stateController.text,
        keySearch: keySearch.text,
        type: typeController.text,
        result: resultController.text,
        createAtMin:
            parseDateToDateTimeWithTimeZone(createAtMinController.text),
        createAtMax:
            parseDateToDateTimeWithTimeZone(createAtMaxController.text),
      ));
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
                testFilter(
                  context,
                  userCodeController: userCodeController,
                  stateController: stateController,
                  typeController: typeController,
                  resultController: resultController,
                  createAtMinController: createAtMinController,
                  createAtMaxController: createAtMaxController,
                  onSubmit: () {
                    setState(() {
                      searched = true;
                    });
                    _pagingController.refresh();
                  },
                  useCustomBottomSheetMode:
                      ResponsiveWrapper.of(context).isLargerThan(MOBILE),
                );
              },
              icon: Icon(Icons.filter_list_outlined),
              tooltip: "Lọc",
            )
          ],
        ),
        body: searched
            ? MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => _pagingController.refresh(),
                  ),
                  child: PagedListView<int, dynamic>(
                    padding: EdgeInsets.only(bottom: 16),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
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
                            Text('Không có dữ liệu'),
                          ],
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                        child: Text('Có lỗi xảy ra'),
                      ),
                      itemBuilder: (context, item, index) => TestNoResultCard(
                        name: item['user'] != null
                            ? item['user']['full_name']
                            : "",
                        gender:
                            item['user'] != null ? item['user']['gender'] : "",
                        birthday: item['user'] != null
                            ? item['user']['birthday'] ?? ""
                            : "",
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
                                      )));
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text('Tìm kiếm phiếu xét nghiệm'),
              ),
      ),
    );
  }
}
