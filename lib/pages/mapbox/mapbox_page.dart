import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_sample/core/entities/place.dart';
import 'package:map_sample/core/gen/assets.gen.dart';
import 'package:map_sample/core/repositories/fetch_geojson.dart';
import 'package:map_sample/core/repositories/fetch_places.dart';
import 'package:map_sample/core/repositories/fetch_route.dart';
import 'package:map_sample/pages/mapbox/annotation_click_listener.dart';
import 'package:map_sample/pages/widgets/current_location_button.dart';
import 'package:map_sample/pages/widgets/place_tile.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapboxPage extends StatefulWidget {
  const MapboxPage({super.key});

  @override
  State<MapboxPage> createState() => _State();
}

class _State extends State<MapboxPage> {
  late final MapboxMap mapboxMap;

  final defaultLatLng = Point(
    coordinates: Position(
      135.4958750992668,
      34.70239193591162,
    ),
  );

  final defaultZoom = 14.0;

  List<Place> _places = [];

  final carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    /// マーカー設定
    Future<void> setupAnnotation(List<Place> places) async {
      final manager =
          await mapboxMap.annotations.createPointAnnotationManager();
      final bytes = await rootBundle.load(Assets.images.redMarker.path);
      final image = bytes.buffer.asUint8List();
      final options = places
          .map(
            (e) => PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  e.geometry.location.lng,
                  e.geometry.location.lat,
                ),
              ),
              textField: e.name,
              textSize: 10,
              textOffset: [0, 2.5],
              textLineHeight: 1.3,
              textJustify: TextJustify.CENTER,
              image: image,
            ),
          )
          .toList();
      await manager.createMulti(options);

      manager.addOnPointAnnotationClickListener(
        AnnotationClickListener(
          onClick: (annotation) {
            mapboxMap.flyTo(
              CameraOptions(center: annotation.geometry),
              MapAnimationOptions(duration: 500, startDelay: 0),
            );

            final index =
                options.indexWhere((e) => e.geometry == annotation.geometry);
            if (index >= 0) {
              carouselController.animateTo(
                300 * index.toDouble(),
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
            }
          },
        ),
      );
    }

    /// ルート設定
    Future<void> setupRoutes(List<List<double>> routes) async {
      final manager =
          await mapboxMap.annotations.createPolylineAnnotationManager();

      final options = [
        PolylineAnnotationOptions(
          geometry: LineString(
            coordinates: routes
                .map(
                  (e) => Position(e.last, e.first),
                )
                .toList(),
          ),
          lineColor: Colors.blueAccent.value,
          lineWidth: 6,
        ),
      ];

      await manager.createMulti(options);
    }

    /// ポリゴン設定
    Future<void> setupPolygon(List<Result> polygonList) async {
      final manager =
          await mapboxMap.annotations.createPolygonAnnotationManager();

      final options = [
        PolygonAnnotationOptions(
          geometry: Polygon(
            coordinates: polygonList
                .map(
                  (e) => e.geoPoints
                      .map(
                        (geoPoint) =>
                            Position(geoPoint.longitude, geoPoint.latitude),
                      )
                      .toList(),
                )
                .toList(),
          ),
          fillColor: Colors.green.withOpacity(0.2).value,
          fillOutlineColor: Colors.green.value,
        ),
      ];
      await manager.createMulti(options);
    }

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            cameraOptions: CameraOptions(
              center: defaultLatLng,
              zoom: defaultZoom,
            ),
            onMapCreated: (mapBox) async {
              mapboxMap = mapBox;

              mapboxMap.scaleBar
                  .updateSettings(ScaleBarSettings(enabled: false))
                  .ignore();
              mapboxMap.compass
                  .updateSettings(CompassSettings(enabled: false))
                  .ignore();

              /// ルート
              final routes = await fetchRoute();
              await setupRoutes(routes);

              /// ポリゴン
              final geoJsons = await fetchGeoJson();
              await setupPolygon(geoJsons);

              /// マーカー
              final places = await fetchPlaces();
              await setupAnnotation(places);
              setState(() {
                _places = places;
              });
            },
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
                      mapboxMap.setCamera(
                        CameraOptions(center: defaultLatLng),
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
