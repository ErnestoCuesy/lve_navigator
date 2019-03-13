import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'screens/tabbed_view.dart';

Position currentLocation;

class LVENavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directory(),
    );
  }
}

class Directory extends StatefulWidget {
  @override
  DirectoryState createState() => new DirectoryState();
}

class DirectoryState extends State<Directory> {
  @override
  void initState() {
    super.initState();
    determineCurrentLocation();
  }

  determineCurrentLocation() {
    Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    ).then((currLoc) {
      setState(() {
        currentLocation = currLoc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabbedView(currentLocation: currentLocation);
  }

}
