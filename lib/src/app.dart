import 'dart:io';
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
    );
  }
}

class Directory extends StatefulWidget {
  @override
  DirectoryState createState() => new DirectoryState();
}

class DirectoryState extends State<Directory> {
  Position currentLocation;
  PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    _determinePermissions();
  }

  _determinePermissions(){
    PermissionHandler().checkPermissionStatus(PermissionGroup.location)
        .then(_updatePermissions);
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
    if (currentLocation != null){
      return TabbedView(currentLocation: currentLocation);
    } else {
      return LoadingView();
    }
  }

}
