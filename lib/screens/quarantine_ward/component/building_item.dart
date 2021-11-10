import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qlkcl/screens/quarantine_management/building_details_screen.dart';

class BuildingItem extends StatelessWidget {
  final String building_name;
  final int maxMem;
  final int currentMem;

  const BuildingItem({
    required this.building_name,
    this.maxMem = 300,
    this.currentMem = 0,
  });

  void selectBuilding(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          BuildingDetailsScreen.routeName,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 76,
            width: MediaQuery.of(context).size.width * 0.3,
            //margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/svg/building.svg'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: Color.fromRGBO(238, 234, 255, 1),
            ),
          ),
          Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(7, 6, 0, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 14,
                        color: CustomColors.secondaryText,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$currentMem' + '/$maxMem',
                        softWrap: true,
                        //overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
