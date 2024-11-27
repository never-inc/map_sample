import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:map_sample/core/entities/place.dart';
import 'package:map_sample/core/gen/assets.gen.dart';

Future<List<Place>> fetchPlaces() async {
  final data = await rootBundle.loadString(Assets.json.spots);
  final jsonList = jsonDecode(data) as List<dynamic>;
  final result =
      jsonList.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();

  return result;
}
