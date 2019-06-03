import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/tabbed_view.dart';
import 'screens/loading_view.dart';

class LVENavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directory(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Directory extends StatefulWidget {
  @override
  DirectoryState createState() => new DirectoryState();
}

class DirectoryState extends State<Directory> {
  Geolocator _geolocator;
  Position currentLocation;
  PermissionStatus _permissionStatus;
  StreamSubscription positionStream;
  LocationOptions locationOptions;

  @override
  void initState() {
    super.initState();
    _determinePermissions();
  }


  @override
  void dispose() {
    positionStream.cancel();
  }

  _determinePermissions(){
    PermissionHandler().checkPermissionStatus(PermissionGroup.location)
        .then((status) => _updatePermissions(status));
  }

  _updatePermissions(PermissionStatus status){
    if (_permissionStatus != status) {
      setState(() {
        _permissionStatus = status;
        if (_permissionStatus == PermissionStatus.granted){
          // print('Permission had already been granted... determining location...');
          _determineCurrentLocation();
        } else {
          // print('Permission not granted yet... asking...');
          PermissionHandler().requestPermissions([PermissionGroup.location])
            .then((permission){
              if (permission[PermissionGroup.location] == PermissionStatus.granted){
                // print('Permission granted... determining location...');
                _determineCurrentLocation();
              } else {
                // print('Permission not granted by user... exiting...');
                exit (0);
              }
          });
        }
      });
    }
  }

  _determineCurrentLocation() {
    _geolocator = Geolocator();
    locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
    positionStream = _geolocator.getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation != null){
      return TabbedView(currentLocation: currentLocation);
    } else {
      return LoadingView();
    }
  }

}
