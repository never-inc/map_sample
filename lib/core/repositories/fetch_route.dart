import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:map_sample/core/gen/assets.gen.dart';

Future<List<List<double>>> fetchRoute() async {
  final data = await rootBundle.loadString(Assets.json.route);
  final jsonList = jsonDecode(data) as List<dynamic>;
  final result = jsonList
      .map((e) => (e as List<dynamic>).map((d) => d as double).toList())
      .toList();

  return result;
}
