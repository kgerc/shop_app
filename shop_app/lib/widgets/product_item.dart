import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  // ignore: prefer_const_constructors_in_immutables
  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Image.network(imageUrl, fit: BoxFit.cover),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ));
  }
}
