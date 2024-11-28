import 'package:flutter/services.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:map_sample/core/gen/assets.gen.dart';

typedef Result = ({
  String id,
  List<GeoPoint> geoPoints,
});

Future<List<Result>> fetchGeoJson() async {
  final data = await rootBundle.loadString(Assets.json.a271276R);
  final geo = GeoJson();
  await geo.parse(data);

  final results = <Result>[];
  for (var i = 0; i < geo.features.length; i++) {
    final feature = geo.features[i];
    final id = feature.properties?['ID'] as String? ?? '';
    final polygon = geo.polygons[i];
    final geoPoints =
        polygon.geoSeries.expand((element) => element.geoPoints).toList();
    results.add((id: id, geoPoints: geoPoints));
  }

  return results;
}
