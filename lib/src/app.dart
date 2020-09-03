import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lve_navigator2/src/screens/location_services_error.dart';
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
  Position _defaultLocation = Position(longitude: 0, latitude: 0);
  bool _continueFlag = false;

  void _askPermission() {
    requestPermission().then((status) {
      setState(() {
      });
    });
  }

  void _continueWithoutLocation() {
    setState(() {
      _continueFlag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationPermission>(
      future: checkPermission(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingView();
        } else {
          if (snapshot.data == LocationPermission.deniedForever && !_continueFlag) {
            return LocationServicesError(
              askPermission: () => _askPermission(),
              continueWithoutLocation: () => _continueWithoutLocation(),
              message: 'Access to location not granted or location services are off. Please rectify and re-run LVE Navigator.',
            );
          }
          return FutureBuilder<Position>(
              future: getCurrentPosition(desiredAccuracy: LocationAccuracy.best),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return TabbedView(currentLocation: snapshot.data ?? _defaultLocation,);
                } else
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingView();
                } else {
                  return LocationServicesError(
                    askPermission: () => _askPermission(),
                    message: 'Please make sure location services are enabled before proceeding.',
                  );
                }
              }
          );
        }
      },
    );
  }
}
