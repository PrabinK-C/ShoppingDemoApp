import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/orders.dart';
import 'package:shoppingapp/widgets/drawerapp.dart';
import 'package:shoppingapp/widgets/orderitem.dart';

class OrdersSCreen extends StatefulWidget {
  const OrdersSCreen({super.key});
  static const routeName = "/Orderscreen";

  @override
  State<OrdersSCreen> createState() => _OrdersSCreenState();
}

class _OrdersSCreenState extends State<OrdersSCreen> {
  late Future _orderstateFuture;
  Future _obtainedstateFuture() {
    return Provider.of<Order>(context, listen: false).fecthsetorder();
  }

  @override
  void initState() {
    _orderstateFuture = _obtainedstateFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _orderstateFuture,
        builder: (context, datasnapshot) {
          if (datasnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (datasnapshot.error != null) {
              //erro rhandil,ig
              return const Center(
                child: Text('error occured!'),
              );
            } else {
              return Consumer<Order>(
                builder: (context, orderdata, child) => ListView.builder(
                  itemCount: orderdata.orders.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return OrderItem(order: orderdata.orders[i]);
                  },
                ),
              );
            }
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
