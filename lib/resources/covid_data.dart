import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CovidData {
  final String increaseConfirmed;
  final String increaseRecovered;
  final String increaseDeaths;
  final String confirmed;
  final String recovered;
  final String deaths;
  final int lastUpdate;

  CovidData({
    required this.increaseConfirmed,
    required this.increaseRecovered,
    required this.increaseDeaths,
    required this.confirmed,
    required this.recovered,
    required this.deaths,
    required this.lastUpdate,
  });

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return CovidData(
      increaseConfirmed:
          json['data']['VN'][62]["increase_confirmed"].toString(),
      increaseRecovered:
          json['data']['VN'][62]["increase_recovered"].toString(),
      increaseDeaths: json['data']['VN'][62]["increase_deaths"].toString(),
      confirmed: json['data']['VN'][62]["confirmed"].toString(),
      recovered: json['data']['VN'][62]["recovered"].toString(),
      deaths: json['data']['VN'][62]["deaths"].toString(),
      lastUpdate: json['data']['VN'][62]["last_update"],
    );
  }
}

Future<CovidData> fetchCovidList() async {
  final response =
      await http.get(Uri.parse('https://ncovi.vnpt.vn/thongtindichbenh_v2'));
  if (response.statusCode == 200) {
    return CovidData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}
