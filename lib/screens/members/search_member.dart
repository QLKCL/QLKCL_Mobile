import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class SearchMember extends StatefulWidget {
  SearchMember({Key? key}) : super(key: key);

  @override
  _SearchMemberState createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  TextEditingController keySearch = TextEditingController();
  TextEditingController quarantineWardController = TextEditingController();
  TextEditingController quarantineBuildingController = TextEditingController();
  TextEditingController quarantineFloorController = TextEditingController();
  TextEditingController quarantineRoomController = TextEditingController();
  TextEditingController quarantineAtMinController = TextEditingController();
  TextEditingController quarantineAtMaxController = TextEditingController();
  TextEditingController labelController = TextEditingController();

  List<KeyValue> _quarantineWardList = [];
  List<KeyValue> _quarantineBuildingList = [];
  List<KeyValue> _quarantineFloorList = [];
  List<KeyValue> _quarantineRoomList = [];

  bool _searched = false;

  late Future<dynamic> futureMemberList;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    fetchQuarantineWard({
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineWardList = value;
        }));
    fetchQuarantineBuilding({
      'quarantine_ward': quarantineWardController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineBuildingList = value;
        }));
    fetchQuarantineFloor({
      'quarantine_building': quarantineBuildingController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineFloorList = value;
        }));
    fetchQuarantineRoom({
      'quarantine_floor': quarantineFloorController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineRoomList = value;
        }));

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
      final newItems = await fetchMemberList(
        data: filterMemberDataForm(
            keySearch: keySearch.text,
            page: pageKey,
            quarantineWard: quarantineWardController.text,
            quarantineBuilding: quarantineBuildingController.text,
            quarantineFloor: quarantineFloorController.text,
            quarantineRoom: quarantineRoomController.text,
            quarantineAtMin:
                parseDateToDateTimeWithTimeZone(quarantineAtMinController.text),
            quarantineAtMax:
                parseDateToDateTimeWithTimeZone(quarantineAtMaxController.text),
            label: labelController.text),
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
                // maxLines: 1,
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
                        _searched = false;
                      });
                    },
                  ),
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (v) {
                  setState(() {
                    _searched = true;
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
                memberFilter(
                  context,
                  quarantineWardController: quarantineWardController,
                  quarantineBuildingController: quarantineBuildingController,
                  quarantineFloorController: quarantineFloorController,
                  quarantineRoomController: quarantineRoomController,
                  quarantineAtMinController: quarantineAtMinController,
                  quarantineAtMaxController: quarantineAtMaxController,
                  quarantineWardList: _quarantineWardList,
                  quarantineBuildingList: _quarantineBuildingList,
                  quarantineFloorList: _quarantineFloorList,
                  quarantineRoomList: _quarantineRoomList,
                  labelController: labelController,
                  onSubmit: (
                    quarantineWardList,
                    quarantineBuildingList,
                    quarantineFloorList,
                    quarantineRoomList,
                    _searched,
                  ) {
                    setState(() {
                      _searched = true;
                      _quarantineWardList = quarantineWardList;
                      _quarantineBuildingList = quarantineBuildingList;
                      _quarantineFloorList = quarantineFloorList;
                      _quarantineRoomList = quarantineRoomList;
                    });
                    _pagingController.refresh();
                  },
                );
              },
              icon: Icon(Icons.filter_list_outlined),
              tooltip: "Lọc",
            )
          ],
        ),
        body: _searched
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
                      itemBuilder: (context, item, index) => MemberCard(
                            name: item['full_name'] ?? "",
                            gender: item['gender'] ?? "",
                            birthday: item['birthday'] ?? "",
                            room:
                                (item['quarantine_room'] != null
                                        ? "${item['quarantine_room']['name']} - "
                                        : "") +
                                    (item['quarantine_floor'] != null
                                        ? "${item['quarantine_floor']['name']} - "
                                        : "") +
                                    (item['quarantine_building'] != null
                                        ? "${item['quarantine_building']['name']} - "
                                        : "") +
                                    (item['quarantine_ward'] != null
                                        ? "${item['quarantine_ward']['full_name']}"
                                        : ""),
                            lastTestResult: item['positive_test_now'],
                            lastTestTime: item['last_tested'],
                            healthStatus: item['health_status'],
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => UpdateMember(
                                            code: item['code'],
                                          )));
                            },
                            menus: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: CustomColors.disableText,
                              ),
                              onSelected: (result) {
                                if (result == 'update_info') {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => UpdateMember(
                                                code: item['code'],
                                              )));
                                } else if (result ==
                                    'create_medical_declaration') {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              MedicalDeclarationScreen(
                                                phone: item["phone_number"],
                                              )));
                                } else if (result ==
                                    'medical_declare_history') {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ListMedicalDeclaration(
                                                code: item['code'],
                                                phone: item["phone_number"],
                                              )));
                                } else if (result == 'create_test') {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => AddTest(
                                                code: item["code"],
                                                name: item['full_name'],
                                              )));
                                } else if (result == 'test_history') {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => ListTest(
                                                code: item["code"],
                                                name: item['full_name'],
                                              )));
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Text('Cập nhật thông tin'),
                                  value: "update_info",
                                ),
                                PopupMenuItem(
                                  child: Text('Khai báo y tế'),
                                  value: "create_medical_declaration",
                                ),
                                PopupMenuItem(
                                  child: Text('Lịch sử khai báo y tế'),
                                  value: "medical_declare_history",
                                ),
                                PopupMenuItem(
                                  child: Text('Tạo phiếu xét nghiệm'),
                                  value: "create_test",
                                ),
                                PopupMenuItem(
                                  child: Text('Lịch sử xét nghiệm'),
                                  value: "test_history",
                                ),
                              ],
                            ),
                          )),
                ),
              )
            : Center(
                child: Text('Tìm kiếm người cách ly'),
              ),
      ),
    );
  }
}
