import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_sample/pages/flutter_map/flutter_map_page.dart';
import 'package:map_sample/pages/google_map/google_map_page.dart';
import 'package:map_sample/pages/mapbox/mapbox_page.dart';

enum Navigation {
  googleMap('Google Map'),
  flutterMap('Flutter Map'),
  mapbox('Mapbox'),
  ;

  const Navigation(this.title);
  final String title;

  void show(BuildContext context) {
    switch (this) {
      case Navigation.googleMap:
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (_) => const GoogleMapPage(),
            settings: RouteSettings(name: name),
          ),
        );
      case Navigation.flutterMap:
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (_) => const FlutterMapPage(),
            settings: RouteSettings(name: name),
          ),
        );
      case Navigation.mapbox:
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (_) => const MapboxPage(),
            settings: RouteSettings(name: name),
          ),
        );
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pages = Navigation.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: ListView.separated(
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];
          return InkWell(
            onTap: () {
              page.show(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                page.title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          );
        },
        separatorBuilder: (context, _) {
          return const Divider(height: 1);
        },
      ),
    );
  }
}
