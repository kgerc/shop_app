import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavourite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

// User(
// 	displayName: "",
//  	email: aaa@aaa.pl,
//  	emailVerified: false,
//  	isAnonymous: false,
//  	metadata: UserMetadata(
// 		creationTime: 2022-01-26 01:28:47.194,
// 		lastSignInTime: 2022-01-2619:57:25.308
// 	),
//  	phoneNumber: ,
//  	photoURL: null,
//  	providerData, 
// [UserInfo(displayName: , email: aaa@aaa.pl, phoneNumber: , photoURL: null, providerId: password, uid: aaa@aaa.pl)], refreshToken: , tenantId: null, uid: NUdAZbbv69Wdu0yvbVyZbeyy2752)