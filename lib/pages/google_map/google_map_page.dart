import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_sample/core/repositories/fetch_places.dart';
import 'package:map_sample/pages/widgets/current_location_button.dart';

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

  @override
  void initState() {
    super.initState();
    Future(() async {
      final places = await fetchPlaces();
      print(places);
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
            onMapCreated: (mapController) async {
              _mapController = mapController;
              await _mapController?.moveCamera(
                CameraUpdate.newLatLngZoom(defaultLatLng, defaultZoom),
              );
            },
            initialCameraPosition: CameraPosition(
              target: defaultLatLng,
            ),
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
                mainAxisSize: MainAxisSize.min,
                children: [
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
        ],
      ),
    );
  }
}
