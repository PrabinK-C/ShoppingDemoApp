import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/products_provider.dart';
import 'package:shoppingapp/screen/edit_prodcut.dart';
import 'package:shoppingapp/widgets/drawerapp.dart';
import 'package:shoppingapp/widgets/userprodcutitem.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const routeName = "/UPS";

  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndsetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Products "),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditprodcutScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshproducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productdata, _) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: productdata.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductitem(
                                  id: productdata.items[i].id,
                                  title: productdata.items[i].title,
                                  imageUrl: productdata.items[i].imageUrl),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
