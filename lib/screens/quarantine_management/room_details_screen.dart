import 'package:flutter/material.dart';
import 'component/general_info_room.dart';
import '../../components/cards.dart';
import './edit_room_screen.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/room-details';
  @override
  _RoomDetailsScreen createState() => _RoomDetailsScreen();
}

class _RoomDetailsScreen extends State<RoomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Thông tin chi tiết phòng"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              EditRoomScreen.routeName,
            );
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child: GeneralInfoRoom(
                  'Ký túc xá khu A', 'Tòa AH', 'Tầng 3', 'Phòng 307', 3, 4),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75,
              //margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  //last item
                  if (index == 8) {
                    return Column(
                      children: [
                        MemberInRoom(
                          onTap: () {},
                          id: '1',
                          name: 'Nguyễn Văn Hải',
                          gender: 'male',
                          birthday: '18/04/1997',
                          lastTestResult: 'Âm tính',
                          lastTestTime: '22/10/2021',
                        ),
                        SizedBox(height: 70),
                      ],
                    );
                  } else
                    return MemberInRoom(
                      onTap: () {},
                      id: '1',
                      name: 'Nguyễn Văn Hải',
                      gender: 'male',
                      birthday: '18/04/1997',
                      lastTestResult: 'Âm tính',
                      lastTestTime: '22/10/2021',
                    );
                },
                itemCount: 9,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
