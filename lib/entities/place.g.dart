// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      businessStatus: json['business_status'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      icon: json['icon'] as String,
      iconBackgroundColor: json['icon_background_color'] as String,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String,
      name: json['name'] as String,
      openingHours:
          OpeningHours.fromJson(json['opening_hours'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeId: json['place_id'] as String,
      plusCode: PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reference: json['reference'] as String,
      scope: json['scope'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      userRatingsTotal: (json['user_ratings_total'] as num).toInt(),
      vicinity: json['vicinity'] as String,
      detail: Detail.fromJson(json['detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'business_status': instance.businessStatus,
      'geometry': instance.geometry.toJson(),
      'icon': instance.icon,
      'icon_background_color': instance.iconBackgroundColor,
      'icon_mask_base_uri': instance.iconMaskBaseUri,
      'name': instance.name,
      'opening_hours': instance.openingHours.toJson(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'place_id': instance.placeId,
      'plus_code': instance.plusCode.toJson(),
      'rating': instance.rating,
      'reference': instance.reference,
      'scope': instance.scope,
      'types': instance.types,
      'user_ratings_total': instance.userRatingsTotal,
      'vicinity': instance.vicinity,
      'detail': instance.detail.toJson(),
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      viewport: Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location.toJson(),
      'viewport': instance.viewport.toJson(),
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Viewport _$ViewportFromJson(Map<String, dynamic> json) => Viewport(
      northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ViewportToJson(Viewport instance) => <String, dynamic>{
      'northeast': instance.northeast.toJson(),
      'southwest': instance.southwest.toJson(),
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      openNow: json['open_now'] as bool,
    );

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'open_now': instance.openNow,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      height: (json['height'] as num).toInt(),
      htmlAttributions: (json['html_attributions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      photoReference: json['photo_reference'] as String,
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'height': instance.height,
      'html_attributions': instance.htmlAttributions,
      'photo_reference': instance.photoReference,
      'width': instance.width,
    };

PlusCode _$PlusCodeFromJson(Map<String, dynamic> json) => PlusCode(
      compoundCode: json['compound_code'] as String,
      globalCode: json['global_code'] as String,
    );

Map<String, dynamic> _$PlusCodeToJson(PlusCode instance) => <String, dynamic>{
      'compound_code': instance.compoundCode,
      'global_code': instance.globalCode,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      url: json['url'] as String,
      website: json['website'] as String,
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'geometry': instance.geometry.toJson(),
      'name': instance.name,
      'rating': instance.rating,
      'url': instance.url,
      'website': instance.website,
    };
