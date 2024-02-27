import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Cartitem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  Cartitem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, Cartitem> _items = {};

  Map<String, Cartitem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, cartitems) {
      total += cartitems.price * cartitems.quantity;
    });
    return total;
  }

  void additem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      //changes quantity
      _items.update(
          productId,
          (exevalueitem) => Cartitem(
                id: exevalueitem.id,
                title: exevalueitem.title,
                quantity: exevalueitem.quantity + 1,
                price: exevalueitem.price,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => Cartitem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removesingleitem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid]?.quantity != 1) {
      _items.update(
        productid,
        (updatesixtingCartitem) => Cartitem(
            id: updatesixtingCartitem.id,
            title: updatesixtingCartitem.title,
            quantity: updatesixtingCartitem.quantity,
            price: updatesixtingCartitem.price - 1),
      );
    } else {
      _items.remove(productid);
    }
    notifyListeners();
  }

  void reomveitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
