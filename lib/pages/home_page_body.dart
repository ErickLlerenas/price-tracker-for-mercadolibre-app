import 'package:flutter/material.dart';
import 'package:mercado_libre/widgets/empty.dart';
import 'package:mercado_libre/widgets/items.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class HomePageBody extends StatefulWidget {
  final double price;
  final String title, url, img;

  HomePageBody({this.price, this.title, this.url, this.img});
  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  double price, highest, lowest;
  String img, title, url;
  List items = [];
  bool loaded = false;
  bool added = false;
  Map<String, dynamic> item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readItems().then((response) {
      setState(() {
        items = response;
        loaded = true;
      });
    });
    if (widget.title != null ||
        widget.img != null ||
        widget.price != null ||
        widget.url != null) {
      if (loaded && !added) {
        item = {
          'title': widget.title,
          'img': widget.img,
          'url': widget.url,
          'price': widget.price,
          'highest': widget.price,
          'lowest': widget.price
        };
        setState(() {
          items.add(item);
        });
        writeItems(json.encode(items));
        resetValues();
      }
    }
    return items.length == 0 ? Empty() : Items(items: items);
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

  void resetValues() {
    title = null;
    img = null;
    price = null;
    url = null;
    highest = null;
    lowest = null;
    added = true;
  }
}
