import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/tabbed_widget.dart';

class TabbedView extends StatelessWidget {
  final Position? currentLocation;

  TabbedView({this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: TabbedWidget(currentLocation: currentLocation),
      );
  }
}
