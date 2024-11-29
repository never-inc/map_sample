import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_sample/core/entities/place.dart';
import 'package:map_sample/core/repositories/fetch_geojson.dart';
import 'package:map_sample/core/repositories/fetch_places.dart';
import 'package:map_sample/core/repositories/fetch_route.dart';
import 'package:map_sample/core/use_cases/create_custom_marker.dart';
import 'package:map_sample/pages/google_map/cafe_marker.dart';
import 'package:map_sample/pages/google_map/map_style.dart';
import 'package:map_sample/pages/google_map/marker_type.dart';
import 'package:map_sample/pages/google_map/menu_dialog.dart';
import 'package:map_sample/pages/widgets/current_location_button.dart';
import 'package:map_sample/pages/widgets/menu_button.dart';
import 'package:map_sample/pages/widgets/place_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _State();
}

class _State extends State<GoogleMapPage> {
  final defaultLatLng = const LatLng(
    34.70239193591162,
    135.4958750992668,
  );
  final defaultZoom = 15.0;

  GoogleMapController? _mapController;

  List<Place> _places = [];
  Set<Polyline> _polylines = {};
  Set<Polygon> _polygons = {};

  List<CafeMarker> _cafeMarkers = [];
  List<({Place place, BitmapDescriptor bitmap})> _cafeBitmapDescriptors = [];
  CafeMarker? _selectedCafeMarker = null;
  ({Place place, BitmapDescriptor bitmap})? _selectedCafeBitmapDescriptor =
      null;

  MarkerId? _selectedMarkerId;
  MapType _mapType = MapType.normal;
  MapStyle _mapStyle = MapStyle.light;
  MarkerType _markerType = MarkerType.normal;

  final carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final places = await fetchPlaces();
      final routes = await fetchRoute();
      final geoJsons = await fetchGeoJson();

      setState(() {
        _places = places;

        _polylines = {
          Polyline(
            polylineId: const PolylineId('route1'),
            points: routes.map((e) => LatLng(e.first, e.last)).toList(),
            color: Colors.blueAccent,
            width: 8,
          ),
        };
        _polygons = geoJsons
            .map(
              (e) => Polygon(
                polygonId: PolygonId(e.id),
                points: e.geoPoints
                    .map((p) => LatLng(p.latitude, p.longitude))
                    .toList(),
                strokeWidth: 4,
                fillColor: Colors.green.withOpacity(0.2),
                strokeColor: Colors.green,
              ),
            )
            .toSet();

        /// カスタムマーカー作成
        _cafeMarkers = places
            .map(
              (e) => CafeMarker(
                id: e.placeId,
                globalKey: GlobalKey(),
                title: e.detail.name,
                rating: e.rating,
                isSelected: false,
              ),
            )
            .toList();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final result = <({Place place, BitmapDescriptor bitmap})>[];
          for (final widget in _cafeMarkers) {
            final bitmap = await createCustomMarker(widget.globalKey);
            if (bitmap == null) {
              continue;
            }
            final id = widget.id;
            final place = places.firstWhereOrNull((e) => e.placeId == id);
            if (place == null) {
              continue;
            }
            result.add(
              (place: place, bitmap: bitmap),
            );
          }

          setState(() {
            _cafeBitmapDescriptors = result;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultMarkers = _places.map((e) {
      final isSelected = _selectedMarkerId?.value == e.placeId;
      return Marker(
        markerId: MarkerId(e.placeId),
        zIndex: isSelected ? 100 : e.rating,
        icon: isSelected
            ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              )
            : BitmapDescriptor.defaultMarker,
        position: LatLng(
          e.geometry.location.lat,
          e.geometry.location.lng,
        ),
        onTap: () {
          final index = _places.indexOf(e);

          carouselController.animateTo(
            300 * index.toDouble(),
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn,
          );
          setState(() {
            final markerId = MarkerId(e.placeId);
            _selectedMarkerId = _selectedMarkerId != markerId ? markerId : null;
          });
        },
      );
    }).toSet();

    final customMarkers = _cafeBitmapDescriptors.map((e) {
      final place = e.place;
      final isSelected = _selectedMarkerId?.value == place.placeId;
      return Marker(
        markerId: MarkerId(place.placeId),
        zIndex: isSelected ? 100 : place.rating,
        icon: isSelected
            ? _selectedCafeBitmapDescriptor?.bitmap ?? e.bitmap
            : e.bitmap,
        position: LatLng(
          place.geometry.location.lat,
          place.geometry.location.lng,
        ),
        onTap: () {
          final index = _places.indexOf(place);

          carouselController.animateTo(
            300 * index.toDouble(),
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn,
          );
          setState(() {
            final markerId = MarkerId(place.placeId);
            final isEnabled = _selectedMarkerId != markerId;
            _selectedMarkerId = isEnabled ? markerId : null;
            _selectedCafeMarker = isEnabled
                ? CafeMarker(
                    id: place.placeId,
                    globalKey: GlobalKey(),
                    title: place.detail.name,
                    rating: place.rating,
                    isSelected: true,
                  )
                : null;
            final selectedCafeMarker = _selectedCafeMarker;
            if (selectedCafeMarker != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final bitmap =
                    await createCustomMarker(selectedCafeMarker.globalKey);
                if (bitmap == null) {
                  return;
                }

                setState(() {
                  _selectedCafeBitmapDescriptor = (
                    place: place,
                    bitmap: bitmap,
                  );
                });
              });
            } else {
              _selectedCafeBitmapDescriptor = null;
            }
          });
        },
      );
    }).toSet();

    final markers = customMarkers;

    return Scaffold(
      body: Stack(
        children: [
          if (_selectedCafeMarker != null) _selectedCafeMarker!,
          ..._cafeMarkers,
          GoogleMap(
            padding: const EdgeInsets.all(16),
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            mapType: _mapType,
            style: _mapStyle.style,
            polylines: _polylines,
            polygons: _polygons,
            onMapCreated: (mapController) async {
              _mapController = mapController;
              await _mapController?.moveCamera(
                CameraUpdate.newLatLngZoom(defaultLatLng, defaultZoom),
              );
            },
            initialCameraPosition: CameraPosition(
              target: defaultLatLng,
            ),
            markers: markers,
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MenuButton(
                      onPressed: () {
                        MenuDialog.show(
                          context,
                          mapType: _mapType,
                          mapStyle: _mapStyle,
                          markerType: _markerType,
                          onChangedMapType: (result) {
                            setState(() {
                              _mapType = result;
                            });
                          },
                          onChangedMapStyle: (result) {
                            setState(() {
                              _mapStyle = result;
                            });
                          },
                          onChangedMarkerType: (result) {
                            setState(() {
                              _markerType = result;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  CurrentLocationButton(
                    onPressed: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(defaultLatLng, defaultZoom),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 100,
                  child: CarouselView(
                    controller: carouselController,
                    itemExtent: 300,
                    onTap: (index) {
                      final data = _places[index];
                      launchUrlString(data.detail.url);
                    },
                    children: _places
                        .map(
                          (e) => PlaceTile(place: e),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
