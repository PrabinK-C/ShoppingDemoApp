import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavourite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _setfavvalue(bool newvalue) {
    isFavourite = newvalue;
  }

  void toogleFavourite(String token, String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.https('shoppingapp-aef8f-default-rtdb.firebaseio.com',
        'UserFavouritesproducts/$userId/$id.json', {
      'auth': token,
    });
    try {
      final response = await http.put(url,
          body: json.encode({
            isFavourite,
          }));
      if (response.statusCode >= 400) {
        _setfavvalue(oldstatus);
        print(oldstatus);
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldstatus;
      print(oldstatus);
      notifyListeners();
    }
  }
}
