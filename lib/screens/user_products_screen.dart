import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const id = "UserProductsScreen";

  @override
  Widget build(BuildContext context) {
    print("Inside build function of userProductsScreen");

    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.id);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProductsProvider>(context, listen: false)
              .fetchAndSetProducts();
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) =>
                Column(
                  children: <Widget>[
                    UserProductItem(
                        id: productsData.items[index].id,
                        title: productsData.items[index].title,
                        imageUrl: productsData.items[index].imageUrl),
                    Divider(),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
