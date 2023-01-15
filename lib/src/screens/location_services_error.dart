import 'package:flutter/material.dart';
import 'package:lvenavigator2/src/screens/empty_content.dart';
import 'package:lvenavigator2/src/widgets/form_submit_button.dart';

class LocationServicesError extends StatelessWidget {
  final Function? askPermission;
  final Function? continueWithoutLocation;
  final String? message;

  const LocationServicesError(
      {Key? key,
      this.askPermission,
      this.continueWithoutLocation,
      this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Theme.of(context).splashColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LVE Navigator',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              padding: EdgeInsets.all(32.0),
              child: EmptyContent(
                title: 'Unknown location',
                message: message,
              ),
            ),
            FormSubmitButton(
              context: context,
              color: Colors.grey,
              text: 'Retry',
              onPressed: askPermission as void Function()?,
            ),
            SizedBox(
              height: 16.0,
            ),
            FormSubmitButton(
              context: context,
              color: Colors.grey,
              text: 'Continue',
              onPressed: continueWithoutLocation as void Function()?,
            ),
          ],
        ),
      ),
    );
  }
}
