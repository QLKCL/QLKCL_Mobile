import 'package:flutter/material.dart';
import 'package:qlkcl/helper/authentication.dart';
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QrImage(
              data: qrData,
              size: 100,
            ),
            FutureBuilder(
              future: getName(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      snapshot.data,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
