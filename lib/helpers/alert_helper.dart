import 'package:flutter/material.dart';
import 'package:mercado_libre/pages/home_page.dart';

showAlert(
    {BuildContext context,
    String title,
    String img,
    String url,
    double price}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: price != 0 ? Text("¿Agregar?") : Text("¡Hey!"),
          content: price != 0
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(text: 'Vamos a agregar el producto '),
                      TextSpan(
                        text: '$title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              ' para analizar su precio. ¡Te enviaremos una nofiticación a tu celular cuando baje de precio!'),
                    ],
                  ),
                )
              : Text("Por favor, agrega un producto válido.",
                  style: TextStyle(color: Colors.grey[600])),
          actions: price != 0
              ? [
                  FlatButton(
                      color: Colors.teal[400],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    title: title,
                                    price: price,
                                    img: img,
                                    url: url)));
                      },
                      child: Text(
                        "AGREGAR",
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
                ]
              : [
                  FlatButton(
                      color: Colors.amber,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
          elevation: 20.0,
        );
      });
}

showLoadingAlert({BuildContext context}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Espera..."),
          content: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amber)),
          elevation: 20.0,
        );
      });
}


