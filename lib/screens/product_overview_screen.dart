import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../widgets/badge.dart';
import '../widgets/product_item.dart';
import '../widgets/product_grid.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    /* Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).fetchAndSetProduct();
    }); */
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context, listen: false).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  Future<void> _refresh(BuildContext context)async{
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  //const ProductsOverviewScreen({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final List<Product> loadedProduct =
    return Scaffold(
      appBar: AppBar(
        title: Text("Vigor Gen"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showOnlyFavourite = true;
                  } else {
                    _showOnlyFavourite = false;
                  }
                });

                //print(selectedValue);
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Favourite"),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text("Show all"),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
        
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavourite),
      ),
    );
  }
}
