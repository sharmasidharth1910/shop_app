import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<ProductsProvider>(context);
    final products = productsData.items;

    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, index) => ProductItem(
        title: products[index].title,
        id: products[index].id,
        imageUrl: products[index].imageUrl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
