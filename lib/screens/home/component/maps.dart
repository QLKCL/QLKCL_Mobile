import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:intl/intl.dart';

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
    required this.startTimeMinController,
    required this.startTimeMaxController,
    this.height = 400,
    required this.refresh,
  }) : super(key: key);
  final String mapData;
  final List<KeyValue> data;
  final TextEditingController startTimeMinController;
  final TextEditingController startTimeMaxController;
  final double height;
  final VoidCallback refresh;

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late MapShapeSource mapSource;
  List<MapModelView> listMapModel = [];
  @override
  void initState() {
    super.initState();
    mapSource = const MapShapeSource.asset('assets/maps/vietnam.json',
        shapeDataField: "NAME_1");
    loadData();
  }

  late final List<MapColorMapper> _shapeColorMappers = <MapColorMapper>[
    MapColorMapper(from: 0, to: 5, color: error.withOpacity(0.2), text: '0-5'),
    MapColorMapper(
        from: 6, to: 20, color: error.withOpacity(0.4), text: '6 - 20'),
    MapColorMapper(
        from: 21, to: 50, color: error.withOpacity(0.6), text: "21 - 50"),
    MapColorMapper(
        from: 51, to: 200, color: error.withOpacity(0.8), text: '51 - 200'),
    MapColorMapper(from: 201, to: 99999999999, color: error, text: '200+'),
  ];

  void loadData() {
    final jsonResult = json.decode(widget.mapData);
    final MapModelAsset mapModel = MapModelAsset.fromJson(jsonResult);

    for (final e in mapModel.features) {
      for (final i in widget.data) {
        if ((i.id.name as String).contains(e.properties.name)) {
          listMapModel.add(MapModelView(
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
  }

  Widget _viewMap() {
    return SfMaps(
      layers: [
        MapShapeLayer(
          source: mapSource,
          legend: MapLegend(
            MapElement.shape,
            position: MapLegendPosition.left,
            offset: const Offset(-10, 0),
            iconType: MapIconType.rectangle,
            enableToggleInteraction: true,
            iconSize: const Size(14, 14),
            textStyle: Theme.of(context).textTheme.bodyText1,
          ),
          strokeColor: Colors.white,
          strokeWidth: 1,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final cellHeight = widget.height - 64;

    return ResponsiveRowColumn(
      layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? ResponsiveRowColumnType.COLUMN
          : ResponsiveRowColumnType.ROW,
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
      rowCrossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: Container(
            height: cellHeight,
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text(
                        "Thống kê người di chuyển",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: _viewMap(),
                      )
                    ],
                  )),
            ),
          ),
        ),
        const ResponsiveRowColumnItem(rowFlex: 1, child: SizedBox()),
      ],
    );
  }
}

/// Collection of Australia state code data.
class MapModelView {
  MapModelView({required this.title, required this.color, required this.total});

  /// Represents the Australia state name.
  final String title;

  /// Represents the Australia state color.
  Color color;

  /// Represents the Australia state code.
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
