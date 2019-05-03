import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<Map> {
  LocationData currentLocation;
  var location = new Location();
  Completer<GoogleMapController> _controller = Completer();
  bool permission = false;
  String error;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    try {
      permission = await location.hasPermission();
      if (!permission) {
        var permissions =
        await Permission.requestPermissions([PermissionName.Location]);
        permission = permissions[0].permissionStatus == PermissionStatus.allow;
      }
      if (permission) {
        currentLocation = await location.getLocation();
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        'Permission denied - please ask the user to enable it from the app settings';
      }
      currentLocation = null;
    }
    if (currentLocation != null) {
      changeCameraPosition(
          LatLng(currentLocation.latitude, currentLocation.longitude));
    }
    print(error.toString());
    fetchPost();
  }

  changeCameraPosition(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: target,
            tilt: 59.440717697143555,
            zoom: 19.151926040649414),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

//  request() {
//    https
//    : //maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
//
//    }

  fetchPost() async {
    final response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyAGZVKAjdk0jX7xeXqGRAwENFDn0Mlv6WE');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
//      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
