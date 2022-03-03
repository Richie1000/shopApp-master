import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          //This provider depends on the immediate previous provider
          ChangeNotifierProxyProvider<Auth, Products>(
              update: (context, auth, prevProduct) => Products(
                    auth.token,
                    (prevProduct == null || prevProduct.items == null)
                        ? []
                        : prevProduct.items,
                      auth.userId
                  )),
          ChangeNotifierProvider.value( 
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, prevOrders) =>Orders(prevOrders == null ? [] : prevOrders.orders, auth.token)
            )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              debugShowCheckedModeBanner: false,
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
