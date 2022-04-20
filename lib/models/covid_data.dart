import 'dart:async';
import 'package:qlkcl/networking/request_helper.dart';
import 'package:intl/intl.dart';

class CovidData {
  final int increaseConfirmed;
  final int increaseRecovered;
  final int increaseDeaths;
  final int confirmed;
  final int recovered;
  final int deaths;
  final int increaseActived;
  final int actived;
  final String lastUpdate;

  CovidData({
    this.increaseConfirmed = 0,
    this.increaseRecovered = 0,
    this.increaseDeaths = 0,
    this.increaseActived = 0,
    this.confirmed = 0,
    this.recovered = 0,
    this.deaths = 0,
    this.actived = 0,
    this.lastUpdate = '',
  });

  factory CovidData.fromJson(json) {
    return json != null
        ? CovidData(
            increaseConfirmed: json["PlusConfirmed"],
            increaseRecovered: json["PlusRecovered"],
            increaseDeaths: json["PlusDeath"],
            confirmed: json["Confirmed"],
            recovered: json["Recovered"],
            deaths: json["Death"],
            actived: json["Confirmed"] - json["Recovered"] - json["Death"],
            lastUpdate: DateFormat("dd/MM/yyyy HH:mm:ss").format(
              DateTime.parse(json["CreatedDate"]),
            ),
          )
        : CovidData();
  }
}

final RequestHelper _provider =
    RequestHelper(baseUrl: "https://emag.thanhnien.vn/covid19/home");

Future<CovidData> fetchCovidList() async {
  final response = await _provider.post("/getSummPatient");
  return CovidData.fromJson(response.data["data"]);
}
