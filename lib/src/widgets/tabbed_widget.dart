import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../resources/app_data.dart';
import '../widgets/map.dart';


class TabbedWidget extends StatelessWidget {

  final Position currentLocation;
  var selectedDestination;

  TabbedWidget({this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.explore),
        bottom: TabBar(
          tabs: [
            Tab(
              text: 'AMENITIES',
            ),
            Tab(
              text: 'Units 001-\n099',
            ),
            Tab(
              text: 'Units 100-\n199',
            ),
            Tab(
              text: 'Units 200-\n314',
            )
          ],
        ),
        title: Text('LVE Navigator'),
      ),
      body: new TabBarView(children: <ListView>[
        _tabBuilder(TAB_AMENITIES),
        _tabBuilder(TAB_UNITS_1_99),
        _tabBuilder(TAB_UNITS_100_199),
        _tabBuilder(TAB_UNITS_200_314),
      ]),
    );
  }

  ListView _tabBuilder(var tab) {
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    var _tabListArray = [];
    switch (tab) {
      case TAB_AMENITIES:
        {
          _tabListArray = placesNamesArr.take(NUMBER_OF_AMENITIES).toList();
        }
        break;
      case TAB_UNITS_1_99:
        {
          _tabListArray =
              placesNamesArr.skip(NUMBER_OF_AMENITIES).take(BATCH_99).toList();
        }
        break;
      case TAB_UNITS_100_199:
        {
          _tabListArray = placesNamesArr
              .skip(NUMBER_OF_AMENITIES + BATCH_99)
              .take(BATCH_99 + 1)
              .toList();
        }
        break;
      case TAB_UNITS_200_314:
        {
          _tabListArray = placesNamesArr
              .skip(NUMBER_OF_AMENITIES + BATCH_99 + BATCH_99 + 1)
              .take(BATCH_99 + BATCH_14 + 2)
              .toList();
        }
        break;
    }
    return ListView.builder(
        itemCount: _tabListArray.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: Colors.transparent,
            child: ListTile(
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 4.0, right: 0.0, bottom: 0.0),
                child: Divider(),
              ),
              onTap: () {
                selectedDestination = calculateArrayPosition(tab, index);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapRoute(
                      currentLocation: currentLocation,
                      selectedDestination: selectedDestination,
                    )
                    )
                );
              },
              title: tileInformation(tab, index, _tabListArray[index]),
              // trailing: trailingIcon(tab, index),
            ),
          );
        });
  }

  Widget tileInformation(int tab, int index, String text){
    if (tab == TAB_AMENITIES){
      switch (index){
        case 0:
        case 1:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.security)),
              Flexible(child: Icon(Icons.directions_car)),
              Text('  $text'),
            ],
          );
        case 2:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.restaurant)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
        case 3:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.content_cut)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
        case 4:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.cake)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
        case 5:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.build)),
              Text('        $text'),
            ],
          );
      }
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(child: Icon(Icons.home)),
          Text(' $text'),
        ],
      );
    }
  }

  calculateArrayPosition(int tab, int index) {
    switch (tab) {
      case TAB_AMENITIES:
        {
          return index;
        }
        break;
      case TAB_UNITS_1_99:
        {
          return index + NUMBER_OF_AMENITIES;
        }
        break;
      case TAB_UNITS_100_199:
        {
          return index + NUMBER_OF_AMENITIES + BATCH_99;
        }
        break;
      case TAB_UNITS_200_314:
        {
          return index + NUMBER_OF_AMENITIES + BATCH_99 + BATCH_99 + 1;
        }
        break;
    }
  }

}