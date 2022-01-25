import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/screens/medical_declaration/detail_md_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:intl/intl.dart';

class ListMedicalDeclaration extends StatefulWidget {
  static const String routeName = "/list_medical_declaration";
  ListMedicalDeclaration({Key? key, this.code, this.phone}) : super(key: key);
  final String? code;
  final String? phone;

  @override
  _ListMedicalDeclarationState createState() => _ListMedicalDeclarationState();
}

class _ListMedicalDeclarationState extends State<ListMedicalDeclaration> {
  late Future<dynamic> futureMedDeclList;
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
      final newItems =
          await fetchMedList(data: {'page': pageKey, 'user_code': code});

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MedicalDeclarationScreen(
                        phone: widget.phone,
                      )))
              .then(
                (value) => _pagingController.refresh(),
              );
        },
        child: Icon(Icons.add),
        tooltip: "Thêm tờ khai",
      ),
      appBar: AppBar(
        title: Text("Lịch sử khai báo y tế"),
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
              itemBuilder: (context, item, index) => MedicalDeclarationCard(
                id: item['code'].toString(),
                time: DateFormat("dd/MM/yyyy HH:mm:ss")
                    .format(DateTime.parse(item['created_at']).toLocal()),
                status: medDeclValueList
                    .safeFirstWhere((result) => result.id == item['conclude'])!
                    .name,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewMD(
                                id: item['id'].toString(),
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
