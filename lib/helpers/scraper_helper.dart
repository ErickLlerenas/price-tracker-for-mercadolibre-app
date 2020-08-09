import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

Future<List> getPriceTitleImage(url) async {
  List priceTitleImage = [];
  double price;
  String title, img;

  //Scrap the URL
  var client = Client();
  Response response = await client.get(url);
  var document = parse(response.body);
  /************************* GET PRICE **************************/
  Element priceElement = document.querySelector('span.price-tag > span.price-tag-fraction');
    
  if (priceElement == null) price = 0;

  if (priceElement != null)
    price = double.parse(
        priceElement.text.replaceFirst('\$', '').replaceAll(',', '').replaceAll('.', ''));

  priceTitleImage.add(price);

  /*************************** GET TITLE ************************/
  Element titleElement = document.querySelector('h1.item-title__primary');

  if (titleElement == null)
    titleElement = document.querySelector('h1.ui-pdp-title');

  if (titleElement != null)
    title = titleElement.text;
  else
    title = "";
  priceTitleImage.add(title);

  /************************* GET IMAGE *****************************/
  Element imageElement = document.querySelector('img[itemprop="thumbnailUrl"]');

  if (imageElement == null)
    imageElement = document.querySelector('figure > a > img');

  if (imageElement == null)
    imageElement = document.querySelector('img.ui-pdp-image');

  if (imageElement != null) img = imageElement.attributes['src'];
  if (imageElement == null) img = "";
  priceTitleImage.add(img);
  return priceTitleImage;
}
