import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/utils/app_theme.dart';

class SimpleQuarantineHistoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String name;
  final String time;
  final String room;
  final String note;
  final Widget? menus;
  const SimpleQuarantineHistoryCard({
    required this.name,
    this.onTap,
    required this.time,
    required this.room,
    this.note = "",
    this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    const SizedBox(
                      height: 4,
                    ),
                    cardLine(
                        icon: Icons.location_on_outlined,
                        title: "Phòng",
                        content: room),
                    const SizedBox(
                      height: 4,
                    ),
                    cardLine(
                        icon: Icons.note_outlined,
                        title: "Ghi chú",
                        content: note),
                  ],
                ),
              ),
              menus ?? Container()
            ],
          ),
        ),
      ),
    );
  }
}
