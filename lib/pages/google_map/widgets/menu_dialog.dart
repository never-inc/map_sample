import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_sample/pages/google_map/enum/map_style.dart';
import 'package:map_sample/pages/google_map/enum/marker_type.dart';

class MenuDialog extends StatefulWidget {
  const MenuDialog({
    super.key,
    required this.mapType,
    required this.mapStyle,
    required this.markerType,
    required this.onChangedMapType,
    required this.onChangedMapStyle,
    required this.onChangedMarkerType,
  });

  final MapType mapType;
  final MapStyle mapStyle;
  final MarkerType markerType;
  final void Function(MapType mapType) onChangedMapType;
  final void Function(MapStyle mapStyle) onChangedMapStyle;
  final void Function(MarkerType markerType) onChangedMarkerType;

  static String get routeName => 'menu_dialog';

  static Future<void> show(
    BuildContext context, {
    required MapType mapType,
    required MapStyle mapStyle,
    required MarkerType markerType,
    required void Function(MapType mapType) onChangedMapType,
    required void Function(MapStyle mapStyle) onChangedMapStyle,
    required void Function(MarkerType markerType) onChangedMarkerType,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MenuDialog(
          mapType: mapType,
          mapStyle: mapStyle,
          markerType: markerType,
          onChangedMapType: onChangedMapType,
          onChangedMapStyle: onChangedMapStyle,
          onChangedMarkerType: onChangedMarkerType,
        );
      },
      routeSettings: RouteSettings(name: routeName),
    );
  }

  @override
  State<MenuDialog> createState() => _State();
}

class _State extends State<MenuDialog> {
  MapType _mapType = MapType.normal;
  MapStyle _mapStyle = MapStyle.light;
  MarkerType _markerType = MarkerType.normal;

  @override
  void initState() {
    super.initState();
    _mapType = widget.mapType;
    _mapStyle = widget.mapStyle;
    _markerType = widget.markerType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('地図の種類')),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      alignment: Alignment.centerRight,
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        _mapType.name,
                        textAlign: TextAlign.start,
                      ),
                      items: MapType.values.map((e) {
                        return DropdownMenuItem<MapType>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: Text(
                              e.name,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        );
                      }).toList(),
                      // value: regionTypeSetting,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _mapType = value;
                        });
                        widget.onChangedMapType(_mapType);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('地図のスタイル')),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      alignment: Alignment.centerRight,
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        _mapStyle.name,
                        textAlign: TextAlign.start,
                      ),
                      items: MapStyle.values.map((e) {
                        return DropdownMenuItem<MapStyle>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: Text(
                              e.name,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        );
                      }).toList(),
                      // value: regionTypeSetting,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _mapStyle = value;
                        });
                        widget.onChangedMapStyle(_mapStyle);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('マーカーピン')),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      alignment: Alignment.centerRight,
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        _markerType.name,
                        textAlign: TextAlign.start,
                      ),
                      items: MarkerType.values.map((e) {
                        return DropdownMenuItem<MarkerType>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: Text(
                              e.name,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        );
                      }).toList(),
                      // value: regionTypeSetting,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _markerType = value;
                        });
                        widget.onChangedMarkerType(_markerType);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
