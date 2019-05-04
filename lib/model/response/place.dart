import 'dart:core';

class Place {
  final String id;
  final String name;
  final String vicinity;
  final Geometry geometry;

  Place({this.id, this.name, this.vicinity, this.geometry});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      vicinity: json['vicinity'],
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class PlacesList {
  final List<Place> places;

  PlacesList({this.places});

  factory PlacesList.fromJson(Map<String, dynamic> json) {
    var results = json['results'];
    return PlacesList(
        places: results.map<Place>((i) => Place.fromJson(i)).toList());
  }
}

class Geometry {
  final SimpleLocation location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: SimpleLocation.fromJson(json['location']),
    );
  }
}

class SimpleLocation {
  final double lat;
  final double lng;

  SimpleLocation({this.lat, this.lng});

  factory SimpleLocation.fromJson(Map<String, dynamic> json) {
    return SimpleLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
