import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
import 'package:places/services/map_api.dart';

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<Map> {
  LocationData currentLocation;
  var location = Location();
  Completer<GoogleMapController> _controller = Completer();
  bool permission = false;
  String error;
  Set<Marker> markers = Set();
  bool isLoading = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
  );

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: markers,
        ),
        Center(
          child: CircularProgressIndicator(
            strokeWidth: isLoading ? 4 : 0,
          ),
        )
      ],
    ));
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
      var location =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      changeCameraPosition(location);
      populateMarkers(location);
    }
    print(error.toString());
  }

  changeCameraPosition(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ));
    }
  }

  populateMarkers(LatLng location) async {
    setState(() {
      isLoading = true;
    });
    var placesList = await MapApi.getPlaces(location, 'atm', 1000);
    if (placesList != null) {
      List<Marker> markersList = placesList.places
          .map<Marker>((i) => Marker(
              markerId: MarkerId(i.id),
              position:
                  LatLng(i.geometry.location.lat, i.geometry.location.lng),
              infoWindow: InfoWindow(title: i.name)))
          .toList();
      if (markersList.length > 0) {
        markers.addAll(markersList);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
