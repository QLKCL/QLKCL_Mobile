import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';

class GeneralInfoFloor extends StatelessWidget {
  final Quarantine currentQuarantine;
  final Building currentBuilding;
  final Floor currentFloor;

  final int numOfRoom;

  const GeneralInfoFloor({
    required this.numOfRoom,
    required this.currentQuarantine,
    required this.currentBuilding,
    required this.currentFloor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(159, 217, 255, 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            left: -80,
            child: SvgPicture.asset('assets/svg/ovaldecoration.svg'),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            text: currentQuarantine.fullName,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          currentBuilding.name + ' - ' + currentFloor.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Tổng số phòng: $numOfRoom',
                            style: const TextStyle(
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Đang cách ly',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.groups_rounded,
                              size: 20,
                              color: CustomColors.primaryText,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${currentFloor.numCurrentMember}/' +
                                  (currentFloor.totalCapacity == null
                                      ? '0'
                                      : currentFloor.totalCapacity.toString()),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
