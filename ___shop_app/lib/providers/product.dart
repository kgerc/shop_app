import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'products.dart';

class Product with ChangeNotifier {
	final String id;
	final String title;
	final String description;
	final double price;
	final String imageUrl;
	bool isFavorite;

	// final FirebaseAuth auth = FirebaseAuth.instance;
	// final User user = auth.currentUser;
	// final uid = user.uid;


	Product({
		required this.id,
		required this.title,
		required this.description,
		required this.price,
		required this.imageUrl,
		this.isFavorite = false,
	});

	void toggleFavouriteStatus(BuildContext context) {
		final User user = FirebaseAuth.instance.currentUser!;

		//addToFavourite(user);
		isFavorite = !isFavorite;

		Provider.of<Products>(context, listen: false).updateFavourite(user);

		notifyListeners();
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