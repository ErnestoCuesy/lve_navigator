import 'package:flutter/material.dart';
import 'package:lve_navigator2/src/resources/app_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(privacyPolicyUrl));
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
