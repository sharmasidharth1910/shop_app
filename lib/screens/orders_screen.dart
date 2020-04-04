import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const id = "OrdersScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //Do error handling here
              return Center(
                child: Text("An error occurred!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) =>
                    ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) =>
                          OrderItemWidget(
                            order: orderData.orders[index],
                          ),
                    ),
              );
            }
          }
        },
      ),
    );
  }
}
