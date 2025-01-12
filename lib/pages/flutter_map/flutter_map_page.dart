import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_sample/core/entities/place.dart';
import 'package:map_sample/core/repositories/fetch_geojson.dart';
import 'package:map_sample/core/repositories/fetch_places.dart';
import 'package:map_sample/core/repositories/fetch_route.dart';
import 'package:map_sample/pages/widgets/current_location_button.dart';
import 'package:map_sample/pages/widgets/place_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FlutterMapPage extends StatefulWidget {
  const FlutterMapPage({super.key});

  @override
  State<FlutterMapPage> createState() => _State();
}

class _State extends State<FlutterMapPage> {
  final defaultLatLng = const LatLng(
    34.70239193591162,
    135.4958750992668,
  );
  final defaultZoom = 15.0;

  final _mapController = MapController();

  List<Place> _places = [];
  List<Polyline> _polylines = [];
  List<Polygon> _polygons = [];

  int? _selectedMarkerId;

  final carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final places = await fetchPlaces();
      final routes = await fetchRoute();
      final geoJsons = await fetchGeoJson();

      setState(() {
        /// デフォルトマーカー
        _places = places;

        /// ルート
        _polylines = [
          Polyline(
            points: routes.map((e) => LatLng(e.first, e.last)).toList(),
            color: Colors.blueAccent,
            strokeWidth: 8,
          ),
        ];

        /// ポリゴン
        _polygons = geoJsons
            .map(
              (e) => Polygon(
                color: Colors.green.withValues(alpha: 0.2),
                borderColor: Colors.green,
                borderStrokeWidth: 4,
                points: e.geoPoints
                    .map(
                      (geoPoint) => LatLng(
                        geoPoint.latitude,
                        geoPoint.longitude,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = _places.mapIndexed((index, e) {
      final isSelected = _selectedMarkerId == index;
      final point = LatLng(
        e.geometry.location.lat,
        e.geometry.location.lng,
      );

      const fontColor = Colors.black;
      const fontBorderColor = Colors.white;
      const fontSize = 10.0;
      return Marker(
        point: point,
        width: 120,
        height: 72,
        child: GestureDetector(
          onTap: () {
            carouselController.animateTo(
              300 * index.toDouble(),
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceIn,
            );
            final currentZoom = _mapController.camera.zoom;
            _mapController.move(point, currentZoom);
            setState(() {
              _selectedMarkerId = _selectedMarkerId != index ? index : null;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pin_drop_sharp,
                size: 40,
                color: isSelected ? Colors.deepPurple : Colors.redAccent,
              ),
              Flexible(
                child: Text(
                  e.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                    fontSize: fontSize,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        offset: Offset(-1.5, -1.5),
                        color: fontBorderColor,
                      ),
                      Shadow(
                        offset: Offset(1.5, -1.5),
                        color: fontBorderColor,
                      ),
                      Shadow(
                        offset: Offset(1.5, 1.5),
                        color: fontBorderColor,
                      ),
                      Shadow(
                        offset: Offset(-1.5, 1.5),
                        color: fontBorderColor,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialZoom: defaultZoom,
              initialCenter: defaultLatLng,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom |
                    InteractiveFlag.flingAnimation,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
              ),
              PolygonLayer(
                polygons: _polygons,
              ),
              PolylineLayer(
                polylines: _polylines,
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
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
                  CurrentLocationButton(
                    onPressed: () {
                      _mapController.move(defaultLatLng, defaultZoom);
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
