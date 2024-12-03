import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor?> createCustomMarker(
  GlobalKey key, {
  double? width,
  double? height,
}) async {
  try {
    final context = key.currentContext;
    if (context == null) {
      return null;
    }
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      return null;
    }
    if (!context.mounted) {
      return null;
    }
    return BytesMapBitmap(
      byteData.buffer.asUint8List(),
      width: width,
      height: height,
      imagePixelRatio: MediaQuery.maybeDevicePixelRatioOf(context),
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
