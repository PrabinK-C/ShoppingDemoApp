import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/card.dart';
import 'package:shoppingapp/Providers/orders.dart';
import 'package:shoppingapp/widgets/cartitem.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = "/CartScreen";

  @override
  Widget build(BuildContext context) {
    final totalcart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${totalcart.totalamount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(totalcart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: totalcart.items.length,
              itemBuilder: (BuildContext ctx, int i) {
                return CartItemm(
                  id: totalcart.items.values.toList()[i].id,
                  price: totalcart.items.values.toList()[i].price,
                  quantity: totalcart.items.values.toList()[i].quantity,
                  title: totalcart.items.values.toList()[i].title,
                  productid: totalcart.items.keys.toList()[i],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(this.totalcart, {super.key});
  final Cart totalcart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (widget.totalcart.totalamount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Order>(context, listen: false).addorders(
                widget.totalcart.items.values
                    .map((cartitem) => CartItemm(
                          id: cartitem.id,
                          title: cartitem.title,
                          price: cartitem.price,
                          quantity: cartitem.quantity,
                          productid: cartitem.id,
                        ))
                    .toList(),
                widget.totalcart.totalamount,
              );
              setState(() {
                _isloading = false;
              });
              widget.totalcart.clear();
            },
      child: _isloading
          ? const CircularProgressIndicator(
              color: Colors.purpleAccent,
            )
          : Text(
              "Order Now",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
