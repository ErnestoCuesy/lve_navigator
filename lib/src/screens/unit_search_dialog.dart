import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lve_navigator2/src/resources/app_data.dart';
import 'package:lve_navigator2/src/widgets/map.dart';

class UnitSearchDialog extends StatefulWidget {
  const UnitSearchDialog({Key key, this.currentLocation}) : super(key: key);
  final Position currentLocation;

  static Future<void> show(BuildContext context, Position currentLocation) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UnitSearchDialog(currentLocation: currentLocation),
        fullscreenDialog: true
      )
    );
  }

  @override
  _UnitSearchDialogState createState() => _UnitSearchDialogState();
}

class _UnitSearchDialogState extends State<UnitSearchDialog> {
  final _formKey = GlobalKey<FormState>();
  int _unit = 0;

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false
              ),
              decoration: InputDecoration(
                icon: Icon(Icons.home),
                labelText: 'Enter unit number (1 to 314)',
              ),
              validator: (value) {
                var v = int.tryParse(value);
                print('value: $v');
                if (v > 0 && v < 315) {
                  return null;
                }
                return 'Invalid unit number';
              },
              onChanged: (value) => _unit = int.tryParse(value) ?? 0,
            ),
          ),
          RaisedButton(
            child: const Text('OK'),
            onPressed: () => _submit(),
          )
        ],
      ),
    );
  }

  bool _validateForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() {
    if (_validateForm()) {
      _pushMapRoute();
    }
  }

  void _pushMapRoute() {
    print('unit: $_unit');
    int selectedDestination = _unit + NUMBER_OF_AMENITIES - 1;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            MapRoute(
              currentLocation: widget.currentLocation,
              selectedDestination: selectedDestination,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search unit'
        ),
      ),
      body: _buildForm(),
    );
  }

}
