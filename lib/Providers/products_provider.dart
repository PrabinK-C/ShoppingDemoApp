import 'dart:io';
import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get favoriteitems {
    return _items.where((proditem) => proditem.isFavourite).toList();
  }
  // var _shoefavouroiteonly = false;

  List<Product> get items {
    // if (_shoefavouroiteonly) {
    //   return _items.where((proditem) => proditem.isFavourite).toList();
    // }
    return [..._items];
  }

  // void showfavoriteonly() {
  //   _shoefavouroiteonly = true;
  //   notifyListeners();
  // }

  // void showonly() {
  //   _shoefavouroiteonly = false;
  //   notifyListeners();
  // }

  Product findbyId(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndsetProduct(bool filterbyUser) async {
    var filterstring = filterbyUser ? 'orderBy' : "creatorId" == userId;
    var url = Uri.https(
        'shoppingapp-aef8f-default-rtdb.firebaseio.com', '/products.json', {
      'auth': authToken,
      'filterbyUser': filterstring,
    });

    try {
      final response = await http.get(url);
      final extracteddata = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extracteddata == null) {
        return;
      }
      url = Uri.https('shoppingapp-aef8f-default-rtdb.firebaseio.com',
          'UserFavouritesproducts/$userId.json', {
        'auth': authToken,
      });
      final favouriteresponse = await http.get(url);
      final List<Product> loaddedprodutcs = [];
      final favorutedata = json.decode(
        favouriteresponse.body,
      );

      extracteddata.forEach((pordid, proddata) {
        loaddedprodutcs.add(Product(
          id: pordid,
          title: proddata['title'] as String? ?? '',
          description: proddata['description'] as String? ?? '',
          price: proddata['price'] as double? ?? 0,
          imageUrl: proddata['imageUrl'] ??
              'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c32372a6-8043-4089-9eda-de8c54d4b735/dgkkdo1-b4c88cae-4d68-4945-b2b8-719c794da14b.jpg/v1/crop/w_263,h_350,x_0,y_0,scl_0.15767386091127,q_70,strp/tfto_book_iii_act2_ch12_2_by_centurion030_dgkkdo1-350t.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjIyNCIsInBhdGgiOiJcL2ZcL2MzMjM3MmE2LTgwNDMtNDA4OS05ZWRhLWRlOGM1NGQ0YjczNVwvZGdra2RvMS1iNGM4OGNhZS00ZDY4LTQ5NDUtYjJiOC03MTljNzk0ZGExNGIuanBnIiwid2lkdGgiOiI8PTE2NjgifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.KkSFz66MZNBr_L6qk6qZQLrkSc7c1IpJsyHi3nc7Zsc',
          isFavourite:
              favorutedata == null ? false : favorutedata[pordid] ?? false,
        ));
      });

      _items = loaddedprodutcs;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProductd(Product product) async {
    final url = Uri.https(
        'shoppingapp-aef8f-default-rtdb.firebaseio.com', '/products.json', {
      'auth': authToken,
    });
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imagUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newprodcut = Product(
        // id: DateTime.now().toString(),
        id: json.decode(response.body)['name'] ?? '',
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      // _items.add(value);
      _items.add(newprodcut);
      // _items.insert(0, newprodcut);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // void updateproduct(String id, Product nproduct) {
  //   final prodindex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodindex >= 0) {
  //     _items[prodindex] = nproduct;
  //     notifyListeners();
  //   } else {
  //     print('Product not found');
  //   }
  // }
  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.https(
        'shoppingapp-aef8f-default-rtdb.firebaseio.com', '/products/$id.json', {
      'auth': authToken,
    });

    try {
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavourite': newProduct.isFavourite,
        }),
      );

      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        print('Product not found in local list'); // Add this line for debugging
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
        'shoppingapp-aef8f-default-rtdb.firebaseio.com', '/products/$id.json', {
      'auth': authToken,
    });

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);

    if (existingProductIndex >= 0) {
      var existingProduct = _items[existingProductIndex];

      _items.removeAt(existingProductIndex);
      notifyListeners();

      try {
        final response = await http.delete(url);

        if (response.statusCode >= 400) {
          _items.insert(existingProductIndex, existingProduct);
          notifyListeners();
          throw const HttpException('Could not delete product.');
        }

        // Reset existingProduct to a default value or remove it from the list.
        // This depends on your use case.
        existingProduct = Product(
          id: '',
          title: '',
          description: '',
          price: 0.0,
          imageUrl: '',
        );
      } catch (error) {
        print(error);
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        rethrow;
      }
    } else {
      print('Product not found');
    }
  }
}
