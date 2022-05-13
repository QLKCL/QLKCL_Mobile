import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/filters.dart';

Future confirmAlertPopup(
  BuildContext context, {
  required Widget content,
  required Function confirmAction,
}) {
  final filterContent = StatefulBuilder(builder:
      (BuildContext context, StateSetter setState /*You can rename this!*/) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Center(
            child: Text(
              'Xác nhận',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: content,
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  confirmAction.call();
                },
                child: const Text("Xác nhận"),
              ),
            ],
          ),
        ),
      ],
    );
  });

  return showCustomModalBottomSheet(
    context: context,
    builder: (context) => filterContent,
    containerWidget: (_, animation, child) => FloatingModal(
      child: child,
    ),
    expand: false,
    useRootNavigator: true,
  );
}
