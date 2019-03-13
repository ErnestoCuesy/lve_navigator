import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../resources/app_data.dart';
import '../utils/map_utils.dart';

class MapRoute extends StatelessWidget {
  final Position currentLocation;
  final int selectedDestination;

  MapRoute({this.currentLocation, this.selectedDestination});

  @override
  Widget build(BuildContext context) {
    MapUtils mapUtils = MapUtils(
      context: context,
      currentLocation: currentLocation,
      selectedDestination: selectedDestination
    );
    return GoogleMap(
      onMapCreated: mapUtils.onMapCreated,
      cameraTargetBounds: CameraTargetBounds(mapUtils.createTargetBounds()),
      initialCameraPosition: CameraPosition(
          target:
          LatLng(
              (currentLocation.latitude + latitudesArr[selectedDestination]) / 2,
              (currentLocation.longitude + longitudesArr[selectedDestination]) / 2),
          zoom: 18.0),
    );
  }

}
