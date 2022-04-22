import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//cre: https://pub.dev/packages/qr_flutter

class GenerateQrCode extends StatelessWidget {
  final String code;
  final String name;

  const GenerateQrCode({
    Key? key,
    required this.code,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QrImage(
              data: code,
              size: 100,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
