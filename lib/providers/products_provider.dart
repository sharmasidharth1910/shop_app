import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

//  var _showFavouritesOnly = false;

  final String authToken;

  ProductsProvider(this.authToken, this._items);

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavourite == true).toList();
  }

  List<Product> get items {
//    if(_showFavouritesOnly)
//      {
//        return _items.where((prodItem) => prodItem.isFavourite).toList();
//      }
    return [..._items];
  }

//  void showFavouritesOnly()
//  {
//    _showFavouritesOnly = true;
//    notifyListeners();
//  }
//
//  void showAll()
//  {
//    _showFavouritesOnly = false;
//    notifyListeners();
//  }

  Future<void> addProduct(Product product) async {
    final url = "Add your url here";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavourite": product.isFavourite
        }),
      );
      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
        price: product.price,
        description: product.description,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = "Add your url here";
      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print("Error !!");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = "Add your url here";
    final existingProductIndex =
    _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: "Could not delete product.");
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts() async {
    final url = "Add your url here";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((productId, productData) {
        loadedProduct.add(Product(
          id: productId,
          imageUrl: productData['imageUrl'],
          description: productData['description'],
          title: productData['title'],
          isFavourite: productData['isFavourite'],
          price: productData['price'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
