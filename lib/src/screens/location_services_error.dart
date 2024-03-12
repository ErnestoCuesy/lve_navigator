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
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LVE Navigator',
              style: Theme.of(context).textTheme.headlineMedium,
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
              text: 'Ask permission',
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
      );
  }
}
