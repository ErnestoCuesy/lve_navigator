import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../resources/app_data.dart';

class MapUtils {
  BuildContext context;
  Position currentLocation;
  int selectedDestination;
  LatLngBounds bounds;

  MapUtils({this.context, this.currentLocation, this.selectedDestination});

  onMapCreated(GoogleMapController controller) async {

    double zoom;
    double padding = 150.0;
    double width = MediaQuery
        .of(context)
        .size
        .width - padding;
    double height = MediaQuery
        .of(context)
        .size
        .height - padding;

    // Create map bounds
    bounds = createTargetBounds();

    // Build markers title and snippet information for both current location and destination
    List<String> markersInfo = new List<String>();
    NumberFormat fmt = new NumberFormat("0", "en_ZA");
    double nearestDistance;
    String nearestPlace = "";
    double distance;

    // Determine distance to nearest point of current location
    for (int i = 0; i < latitudesArr.length; i++) {
      double distance = await Geolocator().distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          latitudesArr[i],
          longitudesArr[i]);
      if (distance < MINIMUM_DISTANCE) {
        nearestDistance = distance;
        nearestPlace = placesNamesArr[i];
      }
    }

    markersInfo.add('You are here');
    if (nearestPlace.isEmpty) {
      markersInfo.add("...");  // Nowhere near LVE places
    } else {
      var subString = nearestPlace.split('/');
      markersInfo.add(
          "Near to " + subString[0] + " ${fmt.format(nearestDistance)} metres");
    }

    // Format selected destination name (remove text after first / to save screen space)
    var subString = placesNamesArr[selectedDestination].split('/');
    markersInfo.add(subString[0]);;

    // Determine distance to destination
    distance = await Geolocator().distanceBetween(
        bounds.southwest.latitude,
        bounds.southwest.longitude,
        bounds.northeast.latitude,
        bounds.northeast.longitude);
    markersInfo.add("Approx ${fmt.format(distance)} meters away from you.");

    // Clear markers
    controller.clearMarkers();

    // Add destination marker
    controller.addMarker(
        MarkerOptions(
        position: LatLng(
            latitudesArr[selectedDestination],
            longitudesArr[selectedDestination]
        ),
        infoWindowText: InfoWindowText(
            markersInfo[DEST_LOC_TITLE], // Main text
            markersInfo[DEST_LOC_SNIPPET]   // Snippet
        ),
//          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
        icon: BitmapDescriptor.fromAsset('assets/chequered-flag.png')
      )
    );

    // Add current location marker
    controller.addMarker(
        MarkerOptions(
        position: LatLng(
            currentLocation.latitude,
            currentLocation.longitude
        ),
        infoWindowText: InfoWindowText(
            markersInfo[CURR_LOC_TITLE], // Main text
            markersInfo[CURR_LOC_SNIPPET]     // Snippet
        ),
        )
    );

    // Determine correct level of zoom
    zoom =
        getBoundsZoomLevel(bounds.northeast, bounds.southwest, width, height);
    controller.moveCamera(CameraUpdate.zoomTo(zoom));
  }

  LatLngBounds createTargetBounds() {
    // Assume sw (curr) lat and long are less than ne (dest)
    LatLng curr = LatLng(
        currentLocation.latitude, currentLocation.longitude);
    LatLng dest = LatLng(
        latitudesArr[selectedDestination], longitudesArr[selectedDestination]);

    // Calculate SW latitude bounds
    LatLng sw = LatLng(
        min(curr.latitude, dest.latitude), min(curr.longitude, dest.longitude));

    // Calculate NE latitude bounds
    LatLng ne = LatLng(
        max(curr.latitude, dest.latitude), max(curr.longitude, dest.longitude));

    return LatLngBounds(southwest: sw, northeast: ne);
  }

  double getBoundsZoomLevel(LatLng northeast, LatLng southwest, double width,
      double height) {
    const int GLOBE_WIDTH = 256; // a constant in Google's map projection
    const double ZOOM_MAX = 21;
    double latFraction = (latRad(northeast.latitude) -
        latRad(southwest.latitude)) / pi;
    double lngDiff = northeast.longitude - southwest.longitude;
    double lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;
    double latZoom = _zoom(height, GLOBE_WIDTH, latFraction);
    double lngZoom = _zoom(width, GLOBE_WIDTH, lngFraction);
    double zoom = min(min(latZoom, lngZoom), ZOOM_MAX);
    return zoom;
  }

  double latRad(double lat) {
    double sinx = sin(lat * pi / 180);
    double radX2 = log((1 + sinx) / (1 - sinx)) / 2;
    return max(min(radX2, pi), -pi) / 2;
  }

  double _zoom(double mapPx, int worldPx, double fraction) {
    return (log(mapPx / worldPx / fraction) / ln2);
  }

}