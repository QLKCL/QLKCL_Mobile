import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qlkcl/screens/error/error_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:rxdart/rxdart.dart';

// cre: https://pub.dev/packages/qr_code_scanner/example

// can use: https://pub.dev/packages/barcode_scan2/example

class QrCodeScan extends StatefulWidget {
  static const String routeName = "/qr_scan";

  const QrCodeScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final picker = ImagePicker();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (isAndroidPlatform()) {
      controller!.pauseCamera();
    } else if (isIOSPlatform()) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: (isAndroidPlatform() || isIOSPlatform())
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 120,
                  width: 100,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    onPressed: () => _getPhotoByGallery(),
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_library_outlined,
                              size: 30),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Chọn QR từ thư viện",
                          style: TextStyle(
                            color: CustomColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    tooltip: "Chọn hình ảnh",
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: const Text('Quét mã QR'),
          actions: [
            IconButton(
              icon: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data == false) {
                    return const Icon(Icons.flash_off);
                  } else {
                    return const Icon(Icons.flash_on);
                  }
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
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderWidth: 10,
        cutOutBottomOffset: 100,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
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

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      showTextToast("Ứng dụng không có quyền truy cập Camera!");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  parseData(String? qrResult) async {
    controller?.pauseCamera();
    if (qrResult == null || qrResult.contains("...")) {
      await Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Error();
        },
      ));
    } else {
      Navigator.of(context).pop(qrResult);
    }
  }

  void _getPhotoByGallery() {
    controller?.pauseCamera();
    Stream.fromFuture(picker.pickImage(source: ImageSource.gallery))
        .flatMap((file) {
      return Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file!.path));
    }).listen((data) {
      Navigator.of(context).pop(data);
    }).onError((error, stackTrace) {
      if (error.toString().contains("Not found data")) {
        showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Lỗi'),
            content: const Text("Không tìm thấy dữ liệu từ hình ảnh"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        ).then((value) => controller!.resumeCamera());
      } else {
        controller!.resumeCamera();
      }
      print(error.toString());
    });
  }
}
