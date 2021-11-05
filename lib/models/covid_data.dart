import 'dart:async';
import 'package:qlkcl/networking/api_provider.dart';

CovidData covidFromJson(str) => CovidData.fromJson(str);

class CovidData {
  final String increaseConfirmed;
  final String increaseRecovered;
  final String increaseDeaths;
  final String confirmed;
  final String recovered;
  final String deaths;
  final int lastUpdate;

  CovidData({
    this.increaseConfirmed = "0",
    this.increaseRecovered = "0",
    this.increaseDeaths = "0",
    this.confirmed = "0",
    this.recovered = "0",
    this.deaths = "0",
    this.lastUpdate = 0,
  });

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return json['data'] != null && json['data'] != {}
        ? CovidData(
            increaseConfirmed:
                json['data']['VN'][62]["increase_confirmed"].toString(),
            increaseRecovered:
                json['data']['VN'][62]["increase_recovered"].toString(),
            increaseDeaths:
                json['data']['VN'][62]["increase_deaths"].toString(),
            confirmed: json['data']['VN'][62]["confirmed"].toString(),
            recovered: json['data']['VN'][62]["recovered"].toString(),
            deaths: json['data']['VN'][62]["deaths"].toString(),
            lastUpdate: json['data']['VN'][62]["last_update"],
          )
        : CovidData();
  }
}

ApiProvider _provider = ApiProvider(baseUrl: "https://ncovi.vnpt.vn");

Future<CovidData> fetchCovidList() async {
  final response = await _provider.get("/thongtindichbenh_v2");
  return covidFromJson(response);
}
