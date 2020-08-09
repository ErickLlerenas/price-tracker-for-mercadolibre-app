import 'package:flutter/material.dart';
import 'package:mercado_libre/pages/home_page_body.dart';
import 'package:mercado_libre/pages/mercado_libre_page.dart';

class HomePage extends StatelessWidget {
  final String url, title, img;
  final double price;

  HomePage({this.img, this.title, this.url, this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AmazonPage()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
        body: HomePageBody(title: title, url: url, img: img, price: price));
  }
}
