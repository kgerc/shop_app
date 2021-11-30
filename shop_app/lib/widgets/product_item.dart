import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  // ignore: prefer_const_constructors_in_immutables
  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName, arguments: id);
            },
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              // ignore: deprecated_member_use
              color: Colors.orange,
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              // ignore: deprecated_member_use
              color: Colors.orange,
            ),
          )),
    );
  }
}
