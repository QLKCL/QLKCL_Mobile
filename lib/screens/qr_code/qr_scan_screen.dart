import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qlkcl/screens/error/error_screen.dart';

// cre: https://pub.dev/packages/qr_code_scanner/example

// can use: https://pub.dev/packages/barcode_scan2/example

class QrCodeScan extends StatefulWidget {
  static const String routeName = "/qr_scan";
  @override
  State<StatefulWidget> createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        controller!.pauseCamera();
      },
      onFocusGained: () {
        controller!.resumeCamera();
      },
      onVisibilityLost: () {
        print('Visibility Lost.');
      },
      onVisibilityGained: () {
        print('Visibility Gained.');
      },
      onForegroundLost: () {
        controller!.pauseCamera();
      },
      onForegroundGained: () {
        print('Foreground Gained.');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quét mã QR'),
          actions: [
            IconButton(
              icon: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data == false)
                    return const Icon(Icons.flash_on);
                  else
                    return const Icon(Icons.flash_off);
                },
              ),
              tooltip: 'Toggle Flash',
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(flex: 9, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          controller!.resumeCamera();
                        });
                      },
                      child: Text('Tiếp tục'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.pauseCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      parseData(result!.code);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  parseData(String qrResult) async {
    controller?.pauseCamera();
    if (qrResult.contains("...")) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Error();
      }));
    } else {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nội dung'),
          content: Text(qrResult),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ).then((value) => controller!.resumeCamera());
    }
  }
}
