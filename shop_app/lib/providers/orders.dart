import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  Future<void> addOrder(
      List<CartItem> cartProducts, double total, User user) async {
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

    final url =
        'https://shop-app-9f7e6-default-rtdb.firebaseio.com/orders/${user.uid}.json';
    try {
      print(_orders);

      var cartProductsToSend = [];

      for (var item in cartProducts) {
        cartProductsToSend.add({
          "id": item.id,
          "title": item.title,
          "quantity": item.quantity,
          "price": item.price
        });
      }

      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toString(),
            'products': cartProductsToSend
          }));
    } catch (error) {
      rethrow;
    }
  }
}
