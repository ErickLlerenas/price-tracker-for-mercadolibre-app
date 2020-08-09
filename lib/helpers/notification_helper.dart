import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:mercado_libre/helpers/scraper_helper.dart' as Scraper;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future initLocalPushNotification() async {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) async {
  if (payload != null) {
    if (await canLaunch('$payload')) {
      await launch('$payload');
    }
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {}

void showNotification({double price, String title, String url,int index}) async {
  if(title!=null)
  await _itemNotification(price: price, title: title, url: url,index:index);
  if (title == null) {
    readItems().then((response) {
      List items = response;
      _handleBackground(items);
    });
  }
}

Future<void> _itemNotification({double price, String title, String url,int index}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(index, '¡Cómprame ahora!',
      '$title ha bajado de precio a \$$price', platformChannelSpecifics,
      payload: url);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/items10.txt');
}

Future<File> writeItems(String items) async {
  final file = await _localFile;
  return file.writeAsString('$items');
}

Future<List> readItems() async {
  try {
    final file = await _localFile;
    List items = await json.decode(await file.readAsString());
    return items;
  } catch (e) {
    return [];
  }
}

void _handleBackground(List items) {
  items.map((item) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      List priceTitleImage = await Scraper.getPriceTitleImage(item['url']);
      double price = priceTitleImage[0];
      String title = priceTitleImage[1];
      title = title.trim();

      if (price != 0 && price != null) {
        if (price < item['price']) {
          //Cuando bajó de precio
          item['price'] = price;
          if (item['lowest'] > price) item['lowest'] = price;
          writeItems(json.encode(items));
          showNotification(price: price, title: title, url: item['url'],index:items.indexOf(item));
        }
        if (price > item['price']) {
          //Cuando subió de precio
          item['price'] = price;
          if (item['highest'] < price) item['highest'] = price;
          writeItems(json.encode(items));
        }
      }
    });
  }).toList();
}
