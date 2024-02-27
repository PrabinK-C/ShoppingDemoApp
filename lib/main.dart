import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/auth.dart';
import 'package:shoppingapp/Providers/card.dart';
import 'package:shoppingapp/Providers/orders.dart';
import 'package:shoppingapp/Providers/products_provider.dart';
import 'package:shoppingapp/screen/authscreen.dart';
import 'package:shoppingapp/screen/cartscreen.dart';
import 'package:shoppingapp/screen/edit_prodcut.dart';
import 'package:shoppingapp/screen/orderscreen.dart';
import 'package:shoppingapp/screen/products_details_screen.dart';
import 'package:shoppingapp/screen/products_overview_screen.dart';
import 'package:shoppingapp/screen/userporductscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context) => Products('', [], ''),
            update: (ctx, auth, previousProducts) => Products(
              auth.token ?? '',
              previousProducts?.items ?? [],
              auth.userId ?? '',
            ),
          ),
          ChangeNotifierProvider(
            create: (BuildContext ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (BuildContext ctx) => Order(''),
            update: (ctx, auth, previousOrder) => Order(auth.token ?? '',
                previousOrder == null ? [] : previousOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (
            ctx,
            auth,
            _,
          ) =>
              MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              secondaryHeaderColor: Colors.orange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              ProductDetailsSCreen.routeName: (ctx) =>
                  const ProductDetailsSCreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersSCreen.routeName: (ctx) => const OrdersSCreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              EditprodcutScreen.routeName: (ctx) => const EditprodcutScreen(),
            },
          ),
        ));
  }
}
