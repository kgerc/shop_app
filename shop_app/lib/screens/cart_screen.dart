import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                            'Do you want to remove the items from the cart?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: Text('No')),
                          TextButton(
                              onPressed: () {
                                cart.clear();
                                Navigator.of(ctx).pop(false);
                              },
                              child: Text('Yes')),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Chip(
                      label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: cart.totalAmount <= 0
                          ? null
                          : () async {
                              // if (cart.items.length < 1) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text(
                              //           'Do not make an empty order',
                              //         ),
                              //         duration: Duration(seconds: 2)),
                              //   );
                              //   return;
                              // }
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                      cart.items.values.toList(),
                                      cart.totalAmount,
                                      FirebaseAuth.instance.currentUser!);
                              cart.clear();
                            },
                      child: Text('ORDER NOW'),
                    )
                  ],
                )),
          ),
          SizedBox(height: 10),
          cart.totalAmount <= 0
              ? SizedBox(height: 1)
              : CartItem(
                  id: "1",
                  productId: "2",
                  price: 12.99,
                  quantity: 1,
                  title: "Wsparcie dla tworcow",
                ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
