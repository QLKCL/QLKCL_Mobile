import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//cre: https://pub.dev/packages/barcode_scan2

class QrCodeScan extends StatefulWidget {
  const QrCodeScan({Key? key}) : super(key: key);
  @override
  _QrCodeScanState createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  ScanResult? scanResult;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Flash',
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          if (scanResult != null)
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Raw Content'),
                    subtitle: Text(scanResult.rawContent),
                  ),
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _scan();
              },
              child: Text(
                'Quét mã',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: selectedFormats,
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
