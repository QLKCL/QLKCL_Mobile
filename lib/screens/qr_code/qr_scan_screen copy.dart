import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as importer;
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scaner;
import 'package:qlkcl/screens/error/error_screen.dart';

// cre: https://pub.dev/packages/qr_code_scanner/example

// cre: https://pub.dev/packages/google_ml_kit

// can use: https://pub.dev/packages/barcode_scan2/example

class QrCodeScan extends StatefulWidget {
  static const String routeName = "/qr_scan";
  @override
  State<StatefulWidget> createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  scaner.Barcode? result;
  importer.BarcodeScanner barcodeScanner =
      importer.GoogleMlKit.vision.barcodeScanner();
  bool isBusy = false;
  CustomPaint? customPaint;
  scaner.QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ImagePicker? _imagePicker;

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
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () => _getImage(ImageSource.gallery),
            child: Icon(Icons.photo_library_outlined),
            tooltip: "Chọn hình ảnh",
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        body: _buildQrView(context));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return scaner.QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: scaner.QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(scaner.QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      parseData(result!.code);
    });
  }

  void _onPermissionSet(
      BuildContext context, scaner.QRViewController ctrl, bool p) {
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
    barcodeScanner.close();
    super.dispose();
  }

  parseData(String qrResult) async {
    controller?.pauseCamera();
    if (qrResult.contains("...")) {
      await Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Error();
        },
      ));
    } else {
      //   await showDialog<String>(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //       title: const Text('Nội dung'),
      //       content: Text(qrResult),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () => Navigator.pop(context, 'OK'),
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     ),
      //   ).then((value) => controller!.resumeCamera());

      Navigator.of(context, rootNavigator: true)
          .pushReplacement(MaterialPageRoute(
              builder: (context) => UpdateMember(
                    code: qrResult,
                  )));
    }
  }

  Future _getImage(ImageSource source) async {
    controller?.pauseCamera();
    final pickedFile = await _imagePicker?.getImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    } else {
      controller!.resumeCamera();
    }
    setState(() {});
  }

  Future _processPickedFile(PickedFile pickedFile) async {
    final inputImage = importer.InputImage.fromFilePath(pickedFile.path);
    processImage(inputImage);
  }

  Future<void> processImage(importer.InputImage inputImage) async {
    final barcodes = await barcodeScanner.processImage(inputImage);
    if (barcodes.length > 0) {
      Navigator.of(context, rootNavigator: true)
          .pushReplacement(MaterialPageRoute(
              builder: (context) => UpdateMember(
                    code: barcodes[0].value.displayValue.toString(),
                  )));
    }
    if (mounted) {
      setState(() {});
    }
  }
}
