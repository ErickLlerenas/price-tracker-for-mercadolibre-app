import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:mercado_libre/widgets/empty.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mercado_libre/helpers/scraper_helper.dart' as Scraper;
import 'package:mercado_libre/helpers/notification_helper.dart'
    as NotificationHelper;
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:in_app_review/in_app_review.dart';

class Items extends StatefulWidget {
  final List items;

  Items({this.items});

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List items;
  static const _adUnitID = "ca-app-pub-2724614824004700/6670861421";
  // static const _testID = "ca-app-pub-3940256099942544/2247696110";
  final _nativeAdController = NativeAdmobController();
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    NotificationHelper.initLocalPushNotification();
    initPlatformState();
  }

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
      appStoreId: 'com.ejele.tracker_mercado_libre');

  @override
  Widget build(BuildContext context) {
    setState(() {
      items = widget.items;
    });

    double width = MediaQuery.of(context).size.width;
    return items.length != 0
        ? ListView(children: <Widget>[
            items.length > 0
                ? Card(
                    child: Container(
                      height: 330,
                      color: Colors.blue[50],
                      padding: EdgeInsets.all(5),
                      child: NativeAdmob(
                        error: Column(
                          children: [
                            SizedBox(height: 50),
                            Text(
                              '\n¿Te gusta la app?',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Text(
                              '\n¡Regálanos una reseña en Google Play Store!😄\n\n⭐⭐⭐⭐⭐',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Dar reseña 👍',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await _openStoreListing();
                              },
                            )
                          ],
                        ),
                        // Your ad unit id
                        adUnitID: _adUnitID,
                        controller: _nativeAdController,
                        type: NativeAdmobType.full,
                      ),
                    ),
                  )
                : Container(),
            new Wrap(
                children: items
                    .map((item) => new Card(
                          color: item['price'] == item['lowest'] &&
                                  item['price'] != item['highest']
                              ? Color.fromRGBO(240, 255, 240, 1)
                              : item['price'] == item['highest'] &&
                                      item['price'] != item['lowest']
                                  ? Color.fromRGBO(255, 245, 245, 1)
                                  : Colors.white,
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunch('${item['url']}')) {
                                await launch('${item['url']}');
                              }
                            },
                            onLongPress: () {
                              showDeleteAlert(
                                  context, item, widget.items.indexOf(item));
                            },
                            child: Container(
                              width: width / 2.1,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    width: width / 2.1,
                                    height: width / 2.1,
                                    imageUrl: '${item['img'] as String}',
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.amber),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          '${item['title'] as String}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Actual: \$${item['price'] as double}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: item['lowest'] ==
                                                            item['price'] &&
                                                        item['highest'] !=
                                                            item['price']
                                                    ? Colors.teal[400]
                                                    : item['highest'] ==
                                                                item['price'] &&
                                                            item['lowest'] !=
                                                                item['price']
                                                        ? Colors.red[400]
                                                        : Colors.grey[700],
                                                fontSize: 15),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: item['lowest'] !=
                                                  item['highest']
                                              ? Text(
                                                  'Más bajo: \$${item['lowest'] as double}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: item['lowest'] !=
                                                              item['price']
                                                          ? Colors.grey[700]
                                                          : Colors.teal[400],
                                                      fontSize: 15),
                                                )
                                              : null,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: item['lowest'] !=
                                                  item['highest']
                                              ? Text(
                                                  'Más alto: \$${item['highest'] as double}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: item['highest'] !=
                                                              item['price']
                                                          ? Colors.grey[700]
                                                          : Colors.red[400],
                                                      fontSize: 15),
                                                )
                                              : null,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList()),
            items.length > 1
                ? Card(
                    child: Container(
                        color: Colors.blue[50],
                        height: 200,
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              '\n¿Te gusta la app?',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Text(
                              '\n¡Regálanos una reseña en Google Play Store!😄\n⭐⭐⭐⭐⭐',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Dar reseña 👍',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await _openStoreListing();
                              },
                            )
                          ],
                        )),
                  )
                : Container()
          ])
        : Empty();
  }

  showDeleteAlert(BuildContext context, item, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("¿Eliminar?"),
            content: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: '¿Quieres Eliminar '),
                  TextSpan(
                    text: '${item['title']}?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' Ya no podremos analizar su precio.'),
                ],
              ),
            ),
            actions: [
              FlatButton(
                  color: Colors.red[400],
                  onPressed: () {
                    Navigator.pop(context);
                    removeItems(index);
                  },
                  child: Text(
                    "ELIMINAR",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(color: Colors.grey[700]),
                  ))
            ],
            elevation: 20.0,
          );
        });
  }

  void removeItems(int index) {
    List temp = items;
    temp.removeAt(index);
    setState(() {
      items = temp;
    });
    writeItems(json.encode(items));
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

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      _handleBackground();
      BackgroundFetch.finish(taskId);
    }).then((int status) {}).catchError((e) {
      print('$e');
    });
  }

  void _handleBackground() {
    items.map((item) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        List priceTitleImage = await Scraper.getPriceTitleImage(item['url']);
        double price = priceTitleImage[0];
        String title = priceTitleImage[1];
        title = title.trim();

        if (price != 0) {
          if (price < item['price']) {
            item['price'] = price;
            if (item['lowest'] > price) item['lowest'] = price;
            writeItems(json.encode(items));
            NotificationHelper.showNotification(
                price: price,
                title: title,
                url: item['url'],
                index: items.indexOf(item));
          }
          if (price > item['price']) {
            item['price'] = price;
            if (item['highest'] < price) item['highest'] = price;
            writeItems(json.encode(items));
          }
        }
      });
    }).toList();
  }
}
