import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercado_libre/pages/home_page.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:mercado_libre/helpers/notification_helper.dart'
    as NotificationHelper;

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  NotificationHelper.showNotification(title: null);
  BackgroundFetch.finish(taskId);
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(250, 230, 0, 1),
  ));
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tracker Mercado Libre',
        home: HomePage());
  }
}
