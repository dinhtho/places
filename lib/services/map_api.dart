import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:places/model/response/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapApi {
  static Future<PlacesList> getPlaces(
      LatLng location, String type, int radius) async {
    final response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            location.latitude.toString() +
            ',' +
            location.longitude.toString() +
            '&radius=' +
            radius.toString() +
            '&type=' +
            type +
            '&key=AIzaSyAGZVKAjdk0jX7xeXqGRAwENFDn0Mlv6WE');

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return PlacesList.fromJson(body);
    } else {
      throw Exception('Failed to load places');
    }
  }
}
