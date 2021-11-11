class Quarantine {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String countryId;
  final String cityId;
  final String districtId;
  final String wardId;
  final String type;
  //final String address;
  final int quarantineTime;
  final String mainManager;
  final int numOfMem;

  const Quarantine({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.countryId,
    required this.cityId,
    required this.districtId,
    required this.wardId,
    required this.type,
    required this.quarantineTime,
    required this.mainManager,
    this.numOfMem = 0,
  });
}
