import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mercado_libre/helpers/scraper_helper.dart' as Scraper;
import 'package:mercado_libre/helpers/alert_helper.dart' as Alert;

class AmazonPage extends StatefulWidget {
  @override
  _AmazonPageState createState() => _AmazonPageState();
}

class _AmazonPageState extends State<AmazonPage> {
  String url, title, img;
  double price;
  bool isLoading = true;
  WebViewController _controller;
  bool isAProduct = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: "https://www.mercadolibre.com",
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController c) async {
                  _controller = c;
                },
                onPageStarted: (url) {
                  print(url);
                  setState(() {
                    isLoading = false;
                  });

                  if (url.length > 100) {
                    setState(() {
                      isAProduct = true;
                    });
                  }
                },
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.amber)),
                    )
                  : Container()
            ],
          ),
        ),
        floatingActionButton: isAProduct
            ? FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.amber,
                onPressed: () async {
                  Alert.showLoadingAlert(context: context);
                  await getData();
                  Navigator.pop(context);
                  Alert.showAlert(
                      context: context,
                      price: price,
                      url: url,
                      title: title,
                      img: img);
                })
            : Container());
  }

  getData() async {
    List priceTitleImage = [];
    url = await _controller.currentUrl();
    priceTitleImage = await Scraper.getPriceTitleImage(url);
    priceTitleImage = priceTitleImage;
    price = priceTitleImage[0];
    title = priceTitleImage[1];
    img = priceTitleImage[2];
    title = title.trim();
  }
}
