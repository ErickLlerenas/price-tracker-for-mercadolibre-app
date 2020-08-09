import 'package:flutter/material.dart';

class Empty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.loupe,
          color: Colors.grey,
          size: 300.0,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 35.0),
            child: Text(
              "Vacío, agrega un producto en el botón de + para empezar a analizar su precio.",
              style: TextStyle(fontSize: 22.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ))
      ],
    ));
  }
}