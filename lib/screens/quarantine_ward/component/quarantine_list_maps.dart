import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class QuanrantineListMaps extends StatefulWidget {
  // final data;
  QuanrantineListMaps({Key? key}) : super(key: key);
  @override
  _QuanrantineListMapsState createState() => _QuanrantineListMapsState();
}

class _QuanrantineListMapsState extends State<QuanrantineListMaps> {
  List<FilterQuanrantineWard> quarantineWardList = [];

  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late int _currentSelectedIndex = 0;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;
  late bool _isDesktop = true;

  @override
  void initState() {
    fetchQuarantineList(data: {'page_size': PAGE_SIZE_MAX}).then((value) {
      final itemList = value;
      if (this.mounted)
        setState(() {
          _mapController.clearMarkers();
          quarantineWardList.clear();

          itemList.data.forEach((element) {
            quarantineWardList.add(element);

            int length = quarantineWardList.length;
            if (length > 1) {
              _mapController.insertMarker(length - 1);
            } else {
              _mapController.insertMarker(0);
            }
          });
        });
    });
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 19,
      enableDoubleTapZooming: true,
      latLngBounds: const MapLatLngBounds(
          MapLatLng(24, 105.323240), MapLatLng(8, 104.71)),
    );

    super.initState();
  }

  late Future<FilterResponse<FilterQuanrantineWard>> futureData;

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    quarantineWardList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 5 : 4;
      _canUpdateZoomLevel = false;
    }
    _cardHeight = (MediaQuery.of(context).orientation == Orientation.landscape)
        ? (_isDesktop ? 155 : 200)
        : 180;
    _pageViewController = PageController(
        initialPage: _currentSelectedIndex,
        viewportFraction:
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? (_isDesktop ? 0.8 : 0.7)
                : 0.9);

    return Scaffold(
        appBar: AppBar(
          title: Text('Bản đồ các khu cách ly'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            // Positioned.fill(
            //   child: Image.asset(
            //     'images/maps_grid.png',
            //     repeat: ImageRepeat.repeat,
            //   ),
            // ),
            SfMaps(
              layers: <MapLayer>[
                MapTileLayer(
                  /// URL to request the tiles from the providers.
                  ///
                  /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
                  /// zoom level, {x} and {y} — tile coordinates.
                  ///
                  /// We will replace the {z}, {x}, {y} internally based on the
                  /// current center point and the zoom level.
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  zoomPanBehavior: _zoomPanBehavior,
                  controller: _mapController,
                  initialMarkersCount: quarantineWardList.length,
                  tooltipSettings: const MapTooltipSettings(
                    color: Colors.transparent,
                  ),
                  markerTooltipBuilder: (BuildContext context, int index) {
                    if (_isDesktop) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          Container(
                              width: 150,
                              height: 80,
                              color: Colors.grey,
                              child: Image.network(
                                  cloudinary
                                      .getImage(quarantineWardList[index].image)
                                      .toString(),
                                  fit: BoxFit.cover)),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            width: 150,
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    quarantineWardList[index].fullName,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      '${quarantineWardList[index].ward?.name}, ' +
                                          '${quarantineWardList[index].district?.name}, ' +
                                          '${quarantineWardList[index].city?.name}',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                  )
                                ]),
                          ),
                        ]),
                      );
                    }

                    return const SizedBox();
                  },
                  markerBuilder: (BuildContext context, int index) {
                    final double _markerSize =
                        _currentSelectedIndex == index ? 40 : 25;
                    return MapMarker(
                      latitude: quarantineWardList[index].latitude,
                      longitude: quarantineWardList[index].longitude,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (_currentSelectedIndex != index) {
                            _canUpdateFocalLatLng = false;
                            _tappedMarkerIndex = index;
                            _pageViewController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: _markerSize,
                          width: _markerSize,
                          child: FittedBox(
                            child: Icon(Icons.location_on,
                                color: _currentSelectedIndex == index
                                    ? Colors.blue
                                    : Colors.red,
                                size: _markerSize),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: _cardHeight,
                padding: const EdgeInsets.only(bottom: 10),

                /// PageView which shows the world wonder details at the bottom.
                child: PageView.builder(
                  itemCount: quarantineWardList.length,
                  onPageChanged: _handlePageChange,
                  controller: _pageViewController,
                  itemBuilder: (BuildContext context, int index) {
                    final item = quarantineWardList[index];
                    return Transform.scale(
                      scale: index == _currentSelectedIndex ? 1 : 0.85,
                      child: Stack(
                        children: <Widget>[
                          QuarantineItem(
                            id: item.id.toString(),
                            name: item.fullName,
                            currentMem: item.numCurrentMember,
                            manager: item.mainManager?.name,
                            address: (item.address != null
                                    ? "${item.address}, "
                                    : "") +
                                (item.ward != null
                                    ? "${item.ward?.name}, "
                                    : "") +
                                (item.district != null
                                    ? "${item.district?.name}, "
                                    : "") +
                                (item.city != null
                                    ? "${item.city?.name}, "
                                    : "")
                            //      +
                            // (item.country != null
                            //     ? "${item.country?.name}"
                            //     : ""
                            // )
                            ,
                            image: item.image,
                          ),
                          // Adding splash to card while tapping.
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                  Radius.elliptical(10, 10)),
                              onTap: () {
                                if (_currentSelectedIndex != index) {
                                  _pageViewController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          quarantineWardList[_currentSelectedIndex].latitude,
          quarantineWardList[_currentSelectedIndex].longitude);
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}
