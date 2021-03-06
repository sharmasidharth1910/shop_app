import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.description,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = "Add your own url here";
    try {
      final response = await http.patch(url,
          body: json.encode({
            "isFavourite": isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
