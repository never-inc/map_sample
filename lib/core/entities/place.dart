import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  Place({
    required this.businessStatus,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.openingHours,
    required this.photos,
    required this.placeId,
    required this.plusCode,
    required this.rating,
    required this.reference,
    required this.scope,
    required this.types,
    required this.userRatingsTotal,
    required this.vicinity,
    required this.detail,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  final String businessStatus;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final OpeningHours openingHours;
  final List<Photo> photos;
  final String placeId;
  final PlusCode plusCode;
  final double rating;
  final String reference;
  final String scope;
  final List<String> types;
  final int userRatingsTotal;
  final String vicinity;
  final Detail detail;

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}

@JsonSerializable()
class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  final Location location;
  final Viewport viewport;

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) =>
      _$ViewportFromJson(json);

  final Location northeast;
  final Location southwest;

  Map<String, dynamic> toJson() => _$ViewportToJson(this);
}

@JsonSerializable()
class OpeningHours {
  OpeningHours({required this.openNow});

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  final bool openNow;

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Photo {
  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable()
class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) =>
      _$PlusCodeFromJson(json);

  final String compoundCode;
  final String globalCode;

  Map<String, dynamic> toJson() => _$PlusCodeToJson(this);
}

@JsonSerializable()
class Detail {
  Detail({
    required this.geometry,
    required this.name,
    required this.rating,
    required this.url,
    required this.website,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  final Geometry geometry;
  final String name;
  final double rating;
  final String url;
  final String? website;

  Map<String, dynamic> toJson() => _$DetailToJson(this);
}
