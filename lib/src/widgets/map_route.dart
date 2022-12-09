import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../resources/app_data.dart';
import '../utils/map_utils.dart';

class MapRoute extends StatefulWidget {
  final Position? currentLocation;
  final int? selectedDestination;

  MapRoute({this.currentLocation, this.selectedDestination});

  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  late MapUtils mapUtils;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _callBack() {
    setState(() {
      markers = mapUtils.markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    mapUtils = MapUtils(
      mediaSize: MediaQuery.of(context).size,
      currentLocation: widget.currentLocation,
      selectedDestination: widget.selectedDestination,
      callBack: _callBack,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: GoogleMap(
        onMapCreated: mapUtils.onMapCreated,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        cameraTargetBounds: CameraTargetBounds(mapUtils.createTargetBounds()),
        initialCameraPosition: CameraPosition(
            target: LatLng(
                (widget.currentLocation!.latitude +
                        latitudesArr[widget.selectedDestination!]) /
                    2,
                (widget.currentLocation!.longitude +
                        longitudesArr[widget.selectedDestination!]) /
                    2),
            zoom: 18.0),
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: useGoogleNavigation,
          child: Icon(Icons.directions)),
    );
  }

  useGoogleNavigation() async {
    Uri googleApiUrlString =
        "http://maps.google.com/maps?saddr=${widget.currentLocation!.latitude},${widget.currentLocation!.longitude}&daddr=${latitudesArr[widget.selectedDestination!]},${longitudesArr[widget.selectedDestination!]}"
            as Uri;
    print(googleApiUrlString);
    if (await canLaunchUrl(googleApiUrlString)) {
      await launchUrl(googleApiUrlString);
    } else {
      throw 'Could not launch $googleApiUrlString';
    }
  }
}
