import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/destination_history.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/home/component/charts.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_core/theme.dart';

// cre: https://github.com/quocbao238/VietNam-Covid-19-News
// cre: https://gadm.org/download_country_v3.html
// cre: https://github.com/nguyenduy1133/Free-GIS-Data
// cre: https://data.vietnam.opendevelopmentmekong.net/vi/dataset/a-phn-tnh
// cre: https://thisisbinh.me/posts/vietnam-choropleth-map/
// cre: https://github.com/daohoangson/dvhcvn
// cre: https://data.opendevelopmentmekong.net/dataset/a-phn-huyn
// cre: https://rpubs.com/chidungkt/709871

class Maps extends StatefulWidget {
  const Maps({
    Key? key,
    required this.mapData,
    required this.data,
    this.height = 400,
    required this.startTimeMinController,
    required this.startTimeMaxController,
  }) : super(key: key);
  final String mapData;
  final List<KeyValue> data;
  final double height;
  final TextEditingController startTimeMinController;
  final TextEditingController startTimeMaxController;

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late MapShapeSource mapSource;
  List<MapModelView> listMapModel = [];

  @override
  void initState() {
    super.initState();
    mapSource = const MapShapeSource.asset(
      'assets/maps/vietnam.json',
      shapeDataField: "NAME_1",
    );
    loadData();
  }

  late final List<MapColorMapper> _shapeColorMappers = <MapColorMapper>[
    MapColorMapper(from: 0, to: 5, color: error.withOpacity(0.2), text: '0 - 5'),
    MapColorMapper(
        from: 6, to: 20, color: error.withOpacity(0.4), text: '6 - 20'),
    MapColorMapper(
        from: 21, to: 50, color: error.withOpacity(0.6), text: "21 - 50"),
    MapColorMapper(
        from: 51, to: 200, color: error.withOpacity(0.8), text: '51 - 200'),
    MapColorMapper(from: 201, to: 99999999999, color: error, text: '200+'),
  ];

  void loadData() {
    if (widget.mapData != "") {
      final jsonResult = json.decode(widget.mapData);
      final MapModelAsset mapModel = MapModelAsset.fromJson(jsonResult);

      for (final e in mapModel.features) {
        for (final i in widget.data) {
          if ((i.id.name as String).contains(e.properties.name)) {
            listMapModel.add(MapModelView(
              id: i.id.id,
              title: e.properties.name,
              color: primary,
              total: i.name ?? 0,
            ));
            break;
          }
        }
      }

      mapModel.features
          .where((element) => !listMapModel
              .map((e) => e.title)
              .toList()
              .contains(element.properties.name))
          .toList()
          .forEach(
        (e) {
          listMapModel.add(MapModelView(
            title: e.properties.name,
            color: primary,
            total: 0,
          ));
        },
      );

      mapSource = MapShapeSource.asset(
        'assets/maps/vietnam.json',
        shapeDataField: "NAME_1",
        dataCount: listMapModel.length,
        primaryValueMapper: (int index) => listMapModel[index].title,
        shapeColorValueMapper: (int index) =>
            listMapModel[index].total.toDouble(),
        shapeColorMappers: _shapeColorMappers,
      );
      setState(() {});
    }
  }

  Widget _viewMap() {
    return SfMapsTheme(
      data: SfMapsThemeData(
        shapeHoverColor: secondary,
        shapeHoverStrokeColor: white,
        shapeHoverStrokeWidth: 2,
        layerStrokeColor: white,
        layerStrokeWidth: 1,
        selectionColor: primary,
        selectionStrokeWidth: 2,
        selectionStrokeColor: white,
        tooltipColor: primaryText,
        toggledItemStrokeColor: disableText,
      ),
      child: SfMaps(
        layers: [
          MapShapeLayer(
            onWillZoom: (MapZoomDetails detail) {
              return false;
            },
            zoomPanBehavior: MapZoomPanBehavior(
              enableDoubleTapZooming: true,
              maxZoomLevel: 10,
            ),
            onWillPan: (MapPanDetails detail) {
              return true;
            },
            loadingBuilder: (BuildContext context) {
              return const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              );
            },
            source: mapSource,
            onSelectionChanged: (int index) async {
              if (listMapModel[index].id != null) {
                final data = await getAddressWithMembersPassBy(
                    getAddressWithMembersPassByDataForm(
                  addressType: "district",
                  startTimeMin: parseDateTimeWithTimeZone(
                      widget.startTimeMinController.text,
                      time: "00:00"),
                  startTimeMax: parseDateTimeWithTimeZone(
                      widget.startTimeMaxController.text),
                  fatherAddressId: listMapModel[index].id.toString(),
                ));
                if (mounted) {
                  showDetailDestinationHistory(
                    context,
                    data: data,
                    useCustomBottomSheetMode:
                        ResponsiveWrapper.of(context).isLargerThan(MOBILE),
                  );
                }
              }
            },
            legend: const MapLegend(
              MapElement.shape,
              position: MapLegendPosition.left,
              offset: Offset(-10, 0),
              iconType: MapIconType.rectangle,
              enableToggleInteraction: true,
              iconSize: Size(14, 14),
            ),
            shapeTooltipBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${listMapModel[index].title}\n${NumberFormat.decimalPattern().format(listMapModel[index].total)} người",
                  style: TextStyle(color: white),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future showDetailDestinationHistory(
    BuildContext context, {
    data,
    bool useCustomBottomSheetMode = false,
  }) {
    final filterContent = StatefulBuilder(
      builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              100,
          child: DestiantionChart(data: data),
        );
      },
    );

    return !useCustomBottomSheetMode
        ? showBarModalBottomSheet(
            barrierColor: Colors.black54,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            useRootNavigator: !Responsive.isDesktopLayout(context),
            context: context,
            builder: (context) => filterContent,
          )
        : showCustomModalBottomSheet(
            context: context,
            builder: (context) => filterContent,
            containerWidget: (_, animation, child) =>
                FloatingModal(child: child),
            expand: false);
  }

  @override
  Widget build(BuildContext context) {
    return _viewMap();
  }
}

class MapModelView {
  MapModelView({
    this.id,
    required this.title,
    required this.color,
    required this.total,
  });

  int? id;
  final String title;
  Color color;
  int total;
}

class MapModelAsset {
  MapModelAsset({
    required this.type,
    required this.features,
  });

  String type;
  List<Feature> features;

  factory MapModelAsset.fromJson(Map<String, dynamic> json) => MapModelAsset(
        type: json["type"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
      };
}

class Feature {
  Feature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  FeatureType type;
  Geometry geometry;
  Properties properties;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: featureTypeValues.map[json["type"]]!,
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "type": featureTypeValues.reverse[type],
        "geometry": geometry.toJson(),
        "properties": properties.toJson(),
      };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  GeometryType type;
  List<List<List<dynamic>>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: geometryTypeValues.map[json["type"]]!,
        coordinates: List<List<List<dynamic>>>.from(json["coordinates"].map(
            (x) => List<List<dynamic>>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      );

  Map<String, dynamic> toJson() => {
        "type": geometryTypeValues.reverse[type],
        "coordinates": List<dynamic>.from(coordinates.map((x) =>
            List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

enum GeometryType { polygon, multiPolygon }

final geometryTypeValues = EnumValues({
  "MultiPolygon": GeometryType.multiPolygon,
  "Polygon": GeometryType.polygon
});

class Properties {
  Properties({
    required this.name,
  });

  String name;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        name: json["NAME_1"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "NAME_1": name,
      };
}

enum FeatureType { feature }

final featureTypeValues = EnumValues({"Feature": FeatureType.feature});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return map.map((k, v) => MapEntry(v, k));
  }
}
