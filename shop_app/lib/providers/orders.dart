import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/order_item.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}


// class CartItem {
//   final String id;
//   final String title;
//   final int quantity;
//   final double price;


class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future <void> addOrder(List<CartItem> cartProducts, double total, User user) async {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();

    final url = 'https://shop-app-9f7e6-default-rtdb.firebaseio.com/orders/${user.uid}.json';
		try {

      var cartProductsToSend = [];
      
      for (var item in cartProducts) {
        cartProductsToSend.add({
            "id": item.id,
            "title": item.title,
            "quantity": item.quantity,
            "price": item.price
        });
      }

			final response = await http.post(
				Uri.parse(url),
				body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toString(),
          'products': cartProductsToSend
        })
			);
		
		} catch (error) {
			rethrow;
		}

  }




Future<void> fetchAndSetOrders(User user) async {
		final url =
				'https://shop-app-9f7e6-default-rtdb.firebaseio.com/orders/${user.uid}.json';
        
		try {
			final response = await http.get(Uri.parse(url));
			final extractedData = json.decode(response.body) as Map<String, dynamic>;

			final List<OrderItem> loadedOrders = [];
			extractedData.forEach((orderId, orderData) {
        final List<CartItem> productList = [];
        for (var item in orderData['products']) {
          productList.add(CartItem(
            id: item['id'], 
            title: item['title'], 
            quantity: item['quantity'], 
            price: item['price']
          ));
        }
				loadedOrders.add(OrderItem(
					id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: productList
				));
			});
			_orders = loadedOrders;
			notifyListeners();
		} catch (err) {
			rethrow;
		}
	}



}
