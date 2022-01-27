// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  final bool showOnlyNotFavorites;
  ProductsGrid(this.showFavorites, this.showOnlyNotFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    var products = productsData.items;
    if (showOnlyNotFavorites) {
      products = productsData.notFavoriteItems;
    } else if (showFavorites) {
      products = productsData.favoriteItems;
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
