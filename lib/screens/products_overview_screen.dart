import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  static const id = "ProductOverviewScreen";

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

//  @override
//  void initState() {
//    Provider.of<ProductsProvider>(context).fetchAndSetProducts(); // Won't Work
//    Future.delayed(Duration.zero).then((_){
//      Provider.of<ProductsProvider>(context).fetchAndSetProducts();
//    });
//    super.initState();
//  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, child) =>
                Badge(
                  value: cartData.itemCount.toString(),
                  child: child,
                ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All items"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ProductsGrid(showFavorites: _showOnlyFavourites),
    );
  }
}
