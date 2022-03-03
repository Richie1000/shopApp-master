import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
//import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../screens/product_detail_screen.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({ Key key }) : super(key: key);

  /* final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl); */

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData =Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                /* await Provider.of<Products>(context, listen: false)
                    .addFavorite(product.id); */
                product.toggleFavouriteStatus(authData.token, authData.userId);
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Added Item to cart",
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
