import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus();
                },
                // ignore: deprecated_member_use
                color: Colors.orange,
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
                // ignore: deprecated_member_use
                color: Colors.orange,
              ),
            )),
      ),
    );
  }
}
