import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = "https://shop-app-87a35.firebaseio.com/orders.json";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) =>
                CartItem(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  quantity: item['quantity'],
                ),
          )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = "https://shop-app-87a35.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        "dateTime": timeStamp.toIso8601String(),
        "products": cartProducts
            .map((cartproduct) =>
        {
          'id': cartproduct.id,
          "quantity": cartproduct.quantity,
          "title": cartproduct.title,
          "price": cartproduct.price,
        })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
