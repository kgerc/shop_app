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
			appBar: AppBar(title: Text('Your cart')),
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
											onPressed: () {
												if(Provider.of<User?>(context, listen: false) != null)
												{
													Provider.of<Orders>(context, listen: false).addOrder(
														cart.items.values.toList(),
														cart.totalAmount,
                            FirebaseAuth.instance.currentUser!
													);
													cart.clear();
												} else
												{
													Navigator.of(context).pushNamed(LoginScreen.routeName);
													Fluttertoast.showToast(
        												msg: "You have to log in first!",
        												toastLength: Toast.LENGTH_SHORT,
        												gravity: ToastGravity.BOTTOM,
        												timeInSecForIosWeb: 1,
        												backgroundColor: Colors.purple[50],
        												textColor: Colors.black87,
        												fontSize: 16.0
    													);
												}
											},
											child: Text('ORDER NOW'),
										)
									],
								)),
					),
					SizedBox(height: 10),
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
					))
				],
			),
		);
	}
}
