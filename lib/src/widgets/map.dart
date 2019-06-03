import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../resources/app_data.dart';
import '../utils/map_utils.dart';

class MapRoute extends StatelessWidget {
  final Position currentLocation;
  final int selectedDestination;
  var context;

  MapRoute({this.currentLocation, this.selectedDestination});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    MapUtils mapUtils = MapUtils(
      context: context,
      currentLocation: currentLocation,
      selectedDestination: selectedDestination
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: GoogleMap(
        onMapCreated: mapUtils.onMapCreated,
        cameraTargetBounds: CameraTargetBounds(mapUtils.createTargetBounds()),
        initialCameraPosition: CameraPosition(
            target:
            LatLng(
                (currentLocation.latitude + latitudesArr[selectedDestination]) / 2,
                (currentLocation.longitude + longitudesArr[selectedDestination]) / 2),
            zoom: 18.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
          onPressed: useGoogleNavigation,
              child: Icon(Icons.directions)
      ),
    );
  }

  useGoogleNavigation() async {
    var googleApiUrlString =
        "http://maps.google.com/maps?saddr=${currentLocation.latitude},${currentLocation.longitude}&daddr=${latitudesArr[selectedDestination]},${longitudesArr[selectedDestination]}";
    print(googleApiUrlString);
    if (await canLaunch(googleApiUrlString)) {
      await launch(googleApiUrlString);
    } else {
      throw 'Could not launch $googleApiUrlString';
    }

  }

}
