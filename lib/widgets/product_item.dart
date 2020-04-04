import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem({
//    @required this.imageUrl,
//    @required this.title,
//    @required this.id,
//  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailScreen.id,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, child) =>
                IconButton(
                  icon: Icon(
                    product.isFavourite ? Icons.favorite : Icons
                        .favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Added item to the cart !",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  textColor: Colors.white,
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
