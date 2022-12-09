import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/tabbed_widget.dart';

class TabbedView extends StatelessWidget {
  final Position? currentLocation;

  TabbedView({this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.cyan[900],
          secondary: Colors.red,
        ),
        indicatorColor: Colors.red,
      ),
      home: DefaultTabController(
        length: 4,
        child: TabbedWidget(currentLocation: currentLocation),
      ),
    );
  }
}
