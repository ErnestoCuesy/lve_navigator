import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lve_navigator2/src/screens/unit_search_dialog.dart';
import '../resources/app_data.dart';
import '../widgets/map_route.dart';


class TabbedWidget extends StatefulWidget {

  final Position? currentLocation;

  TabbedWidget({this.currentLocation});

  @override
  _TabbedWidgetState createState() => _TabbedWidgetState();
}

class _TabbedWidgetState extends State<TabbedWidget> {
  int? selectedDestination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.explore),
        bottom: TabBar(
          tabs: [
            Tab(
              //text: 'AMENITIES',
              child: _tabText('AMENITIES'),
            ),
            Tab(
              child: _tabText('Units 001 -\n099'),
            ),
            Tab(
              child: _tabText('Units 100 -\n199'),
            ),
            Tab(
              child: _tabText('Units 200 -\n314'),
            )
          ],
        ),
        title: Text('LVE Navigator'),
      ),
      body: new TabBarView(children: <ListView>[
        _tabBuilder(context, TAB_AMENITIES),
        _tabBuilder(context, TAB_UNITS_1_99),
        _tabBuilder(context, TAB_UNITS_100_199),
        _tabBuilder(context, TAB_UNITS_200_314),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => UnitSearchDialog.show(context, widget.currentLocation),
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _tabText(String text) {
    return Text(text, style: TextStyle(fontSize: 11.0),);
  }

  ListView _tabBuilder(BuildContext context, int tab) {
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
    return ListView.separated(
        itemCount: _tabListArray.length + 2,
        separatorBuilder: (context, index) => Divider(height: 0.5,),
        itemBuilder: (context, index) {
          if (index == 0 || index == _tabListArray.length + 1) {
            return Container();
          } else {
            return Material(
              color: Colors.transparent,
              child: ListTile(
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                ),
                onTap: () => _pushMapRoute(context, tab, index),
                title: tileInformation(tab, index - 1, _tabListArray[index - 1]),
                // trailing: trailingIcon(tab, index),
              ),
            );
          }
        });
  }

  void _pushMapRoute(BuildContext context, int tab, int index) {
    selectedDestination = calculateArrayPosition(tab, index - 1);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            MapRoute(
              currentLocation: widget.currentLocation,
              selectedDestination: selectedDestination,
            )
        )
    );
  }

  Widget? tileInformation(int tab, int index, String text){
    Widget? row;
    if (tab == TAB_AMENITIES){
      switch (index){
        case 0:
        case 1:
          row = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.security)),
              Flexible(child: Icon(Icons.directions_car)),
              Text('  $text'),
            ],
          );
          break;
        case 2:
          row = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.restaurant)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
          break;
        case 3:
          row = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.content_cut)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
          break;
        case 4:
          row = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.cake)),
              Flexible(child: Icon(Icons.pool)),
              Text('  $text'),
            ],
          );
          break;
        case 5:
          row = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(child: Icon(Icons.build)),
              Text('        $text'),
            ],
          );
          break;
      }
    } else {
      row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(child: Icon(Icons.home)),
          Text(' $text'),
        ],
      );
    }
    return row;
  }

  int? calculateArrayPosition(int tab, int index) {
    int? pos;
    switch (tab) {
      case TAB_AMENITIES:
        {
          pos = index;
        }
        break;
      case TAB_UNITS_1_99:
        {
          pos = index + NUMBER_OF_AMENITIES;
        }
        break;
      case TAB_UNITS_100_199:
        {
          pos = index + NUMBER_OF_AMENITIES + BATCH_99;
        }
        break;
      case TAB_UNITS_200_314:
        {
          pos = index + NUMBER_OF_AMENITIES + BATCH_99 + BATCH_99 + 1;
        }
        break;
    }
    return pos;
  }
}