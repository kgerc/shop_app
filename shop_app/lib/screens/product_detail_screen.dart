// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments
        as String; // this is the forwarded id
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false, // do not listen every time
    ).findById(productId);

    return Scaffold(
        appBar: AppBar(title: Text(loadedProduct.title)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(loadedProduct.title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 10,
              ),
              Text('\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 10,
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(loadedProduct.id, loadedProduct.price,
                      loadedProduct.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added item to cart!',
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(loadedProduct.id);
                        },
                      ),
                    ),
                  );
                },
                color: Colors.orange,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ],
          ),
        ));
  }
}
