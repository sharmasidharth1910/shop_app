import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (context) => ProductsProvider(null, []),
//          create: (context, auth, previousProducts) =>
//              ProductsProvider(auth.token, previousProducts.items),
          update: (context, auth, previousProducts) =>
              ProductsProvider(
                  auth.token,
                  previousProducts == null ? [] : previousProducts.items),
//          builder: (context, auth, previousProducts) =>
//              ProductsProvider(auth.token, previousProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, []),
          update: (context, auth, previousOrders) =>
              Orders(
                  auth.token,
                  previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: "Lato",
              ),
              home: auth.isAuth ? ProductOverViewScreen() : AuthScreen(),
              routes: {
                CartScreen.id: (context) => CartScreen(),
                EditProductScreen.id: (context) => EditProductScreen(),
                OrdersScreen.id: (context) => OrdersScreen(),
                AuthScreen.id: (context) => AuthScreen(),
                UserProductsScreen.id: (context) => UserProductsScreen(),
                ProductOverViewScreen.id: (context) => ProductOverViewScreen(),
                ProductDetailScreen.id: (context) => ProductDetailScreen(),
              },
            ),
      ),
    );
  }
}
