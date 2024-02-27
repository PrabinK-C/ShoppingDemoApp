import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shoppingapp/widgets/cartitem.dart';
import 'package:http/http.dart' as http;

class OrderItemD {
  final String id;
  final double amount;
  final List<CartItemm> products;
  final DateTime dateTime;
  OrderItemD({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItemD> _orders = [];
  final String authToken;
  Order(this.authToken, [List<OrderItemD>? initialOrders]);

  List<OrderItemD> get orders {
    return [..._orders];
  }

  Future<void> addorders(List<CartItemm> cartProducts, double total) async {
    final url = Uri.https(
      'shoppingapp-aef8f-default-rtdb.firebaseio.com',
      '/orders.json',
      {'auth': authToken},
    );
    final timstamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timstamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItemD(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fecthsetorder() async {
    final url = Uri.https(
        'shoppingapp-aef8f-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    final List<OrderItemD> loadedOrders = [];
    print(response.body);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderdata) {
      loadedOrders.add(
        OrderItemD(
          id: orderId,
          amount: orderdata['amount'],
          products: (orderdata['products'] as List<dynamic>)
              .map((item) => CartItemm(
                    id: item['id'] ?? '',
                    title: item['title'] ?? '',
                    price: item['price'] ?? 0.0,
                    quantity: item['quantity'] ?? 0,
                    productid: item['productid'] ?? '',
                  ))
              .toList(),
          dateTime: orderdata['dateTime'] != null
              ? DateTime.parse(orderdata['dateTime'])
              : DateTime.now(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
