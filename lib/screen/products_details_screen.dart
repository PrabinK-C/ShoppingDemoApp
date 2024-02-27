import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/products_provider.dart';

class ProductDetailsSCreen extends StatelessWidget {
  // final String title;
  // const ProductDetailsSCreen({super.key, required this.title});
  static const routeName = '/PDetails';

  const ProductDetailsSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedproducts = Provider.of<Products>(
      context,
      listen: false,
    ).findbyId(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproducts.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                loadedproducts.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedproducts.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedproducts.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
