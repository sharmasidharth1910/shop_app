import 'package:flutter/foundation.dart';

import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.dateTime,
    @required this.products,
    @required this.amount,
  });
}
