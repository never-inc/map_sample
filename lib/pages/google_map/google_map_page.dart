import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_sample/core/entities/place.dart';
import 'package:map_sample/core/repositories/fetch_places.dart';
import 'package:map_sample/pages/widgets/current_location_button.dart';
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

  Set<Marker> _markers = {};
  List<Place> _places = [];

  final carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final places = await fetchPlaces();
      setState(() {
        _places = places;
        _markers = _places
            .map(
              (e) => Marker(
                markerId: MarkerId(e.placeId),
                zIndex: e.rating,
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
                },
              ),
            )
            .toSet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.all(16),
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (mapController) async {
              _mapController = mapController;
              await _mapController?.moveCamera(
                CameraUpdate.newLatLngZoom(defaultLatLng, defaultZoom),
              );
            },
            initialCameraPosition: CameraPosition(
              target: defaultLatLng,
            ),
            markers: _markers,
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
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CurrentLocationButton(
                    onPressed: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(defaultLatLng, defaultZoom),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
