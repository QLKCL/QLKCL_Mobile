import 'package:flutter/foundation.dart';

class Quarantine {
  final String id;
  final String full_name;
  final String phone_number;
  final String country_id;
  final String city_id;
  final String district_id;
  final String ward_id;
  final String type;
  //final String address;
  final int quarantine_time;
  final String main_manager;

  const Quarantine({
    required this.id,
    required this.full_name,
    required this.phone_number,
    required this.country_id,
    required this.city_id,
    required this.district_id,
    required this.ward_id,
    required this.type,
    required this.quarantine_time,
    required this.main_manager,
  });
}
