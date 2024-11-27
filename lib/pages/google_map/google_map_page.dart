import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  GoogleMapController? _mapController;

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
                CameraUpdate.newLatLngZoom(
                  defaultLatLng,
                  15,
                ),
              );
            },
            initialCameraPosition: CameraPosition(
              target: defaultLatLng,
            ),
          ),
        ],
      ),
    );
  }
}
