import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/vaccine_dose.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

class VaccinationCertificationScreen extends StatefulWidget {
  const VaccinationCertificationScreen({
    Key? key,
    required this.vaccineCertification,
  }) : super(key: key);
  final VaccinationCertification vaccineCertification;

  @override
  _VaccinationCertificationScreenState createState() =>
      _VaccinationCertificationScreenState();
}

class _VaccinationCertificationScreenState
    extends State<VaccinationCertificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tra cứu chứng nhận tiêm',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                if (widget.vaccineCertification.patientInfo.vaccinatedInfoes
                        .length ==
                    0)
                  WebsafeSvg.asset("assets/svg/duong_tinh.svg", height: 100),
                if (widget.vaccineCertification.patientInfo.vaccinatedInfoes
                        .length ==
                    1)
                  WebsafeSvg.asset("assets/svg/nghi_ngo.svg", height: 100),
                if (widget.vaccineCertification.patientInfo.vaccinatedInfoes
                        .length >
                    1)
                  WebsafeSvg.asset("assets/svg/binh_thuong.svg", height: 100),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                  thickness: 2,
                ),
                Text(
                    widget.vaccineCertification.patientInfo.vaccinatedInfoes
                                .length >
                            0
                        ? "Bạn đã tiêm ${widget.vaccineCertification.patientInfo.vaccinatedInfoes.length} mũi vaccine"
                        : "Chưa tiêm vaccine",
                    style: TextStyle(fontSize: 25)),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                  thickness: 2,
                ),
                Card(
                  child: QrImage(
                    padding: EdgeInsets.all(16),
                    data: widget.vaccineCertification.qrCode,
                    size: MediaQuery.of(context).size.width > maxMobileSize
                        ? MediaQuery.of(context).size.width * 0.5
                        : maxMobileSize * 0.5,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Họ và tên: ${widget.vaccineCertification.patientInfo.fullname}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Ngày sinh: ${widget.vaccineCertification.patientInfo.birthday}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Số CMND/CCCD: ${widget.vaccineCertification.patientInfo.identification}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}