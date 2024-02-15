import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lvenavigator2/src/widgets/custom_raised_button.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({Key? key, this.radius = 8, required this.mdFileName})
      : assert(
            mdFileName.contains('.md'), 'The file must have the .md extension'),
        super(key: key);

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 150))
                        .then((value) {
                      return rootBundle.loadString('assets/$mdFileName');
                    }),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return Markdown(data: snapshot.data.toString());
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRaisedButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    height: 40.0,
                    width: 80.0,
                    color: Colors.cyan[900],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
