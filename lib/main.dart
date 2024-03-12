import 'package:flutter/material.dart';
import 'package:lvenavigator2/src/classes/session_notifier.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(    ChangeNotifierProvider<SessionNotifier>(
      create: (_) => SessionNotifier(),
      child: LVENavigator(),
    ),
);
}

