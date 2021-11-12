import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//cre: https://pub.dev/packages/qr_flutter

class GenerateQrCode extends StatelessWidget {
  final String qrData;

  const GenerateQrCode({Key? key, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QrImage(
              data: qrData,
              size: 100,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                qrData,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
