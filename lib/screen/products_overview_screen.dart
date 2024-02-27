import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/card.dart';
import 'package:shoppingapp/Providers/products_provider.dart';
import 'package:shoppingapp/screen/cartscreen.dart';
import 'package:shoppingapp/widgets/drawerapp.dart';
import '../widgets/productGrid.dart';

enum Filteroptions {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showonlyFavorites = false;
  var _isint = true;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndsetProduct(); // wont work

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isint) {
      Provider.of<Products>(context).fetchAndsetProduct(true);
    }
    _isint = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final produtscontainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My shop"),
        actions: [
          PopupMenuButton(
            onSelected: (Filteroptions selectedvalue) {
              setState(() {
                if (selectedvalue == Filteroptions.favourites) {
                  _showonlyFavorites = true;
                } else {
                  _showonlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: Filteroptions.all,
                child: Text("Show All"),
              ),
              const PopupMenuItem(
                value: Filteroptions.favourites,
                child: Text("Only Favouitres"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                label: Text(cart.itemCount.toString()),
                child: ch,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart_checkout,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(
        showonlyFavorites: _showonlyFavorites,
      ),
    );
  }
}
