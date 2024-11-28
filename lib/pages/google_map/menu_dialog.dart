import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_sample/pages/google_map/map_style.dart';

class MenuDialog extends StatefulWidget {
  const MenuDialog({
    super.key,
    required this.mapType,
    required this.mapStyle,
    required this.onChangedMapType,
    required this.onChangedMapStyle,
  });

  final MapType mapType;
  final MapStyle mapStyle;
  final void Function(MapType mapType) onChangedMapType;
  final void Function(MapStyle mapStyle) onChangedMapStyle;

  static String get routeName => 'menu_dialog';

  static Future<void> show(
    BuildContext context, {
    required MapType mapType,
    required MapStyle mapStyle,
    required void Function(MapType mapType) onChangedMapType,
    required void Function(MapStyle mapStyle) onChangedMapStyle,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MenuDialog(
          mapType: mapType,
          mapStyle: mapStyle,
          onChangedMapType: onChangedMapType,
          onChangedMapStyle: onChangedMapStyle,
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

  @override
  void initState() {
    super.initState();
    _mapType = widget.mapType;
    _mapStyle = widget.mapStyle;
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
          ],
        ),
      ),
    );
  }
}
