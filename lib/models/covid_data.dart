import 'dart:async';
import 'package:qlkcl/networking/request_helper.dart';

class CovidData {
  final String increaseConfirmed;
  final String increaseRecovered;
  final String increaseDeaths;
  final String confirmed;
  final String recovered;
  final String deaths;
  final String increaseActived;
  final String actived;
  final String lastUpdate;

  CovidData({
    this.increaseConfirmed = "0",
    this.increaseRecovered = "0",
    this.increaseDeaths = "0",
    this.increaseActived = "0",
    this.confirmed = "0",
    this.recovered = "0",
    this.deaths = "0",
    this.actived = "0",
    this.lastUpdate = '',
  });

  factory CovidData.fromJson(json) {
    return json != null
        ? CovidData(
            increaseConfirmed: json["new_case"].toString(),
            increaseRecovered: json["new_recovered"].toString(),
            increaseDeaths: json["new_death"].toString(),
            increaseActived: json["new_active"].toString(),
            confirmed: json["total_case"].toString(),
            recovered: json["total_recovered"].toString(),
            deaths: json["total_death"].toString(),
            actived: json["total_active"].toString(),
            lastUpdate: json["last_updated"],
          )
        : CovidData();
  }
}

RequestHelper _provider = RequestHelper(baseUrl: "https://covid19.ncsc.gov.vn");

Future<CovidData> fetchCovidList() async {
  final response = await _provider.get("/api/v3/covid/national_total");
  return CovidData.fromJson(response.data);
}
