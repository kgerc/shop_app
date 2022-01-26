import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
	List<Product> _items = [
		//   Product(
		//     id: 'p1',
		//     title: 'Red Shirt',
		//     description: 'A red shirt - it is pretty red!',
		//     price: 29.99,
		//     imageUrl:
		//         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
		//   ),
		//   Product(
		//     id: 'p2',
		//     title: 'Trousers',
		//     description: 'A nice pair of trousers.',
		//     price: 59.99,
		//     imageUrl:
		//         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
		//   ),
		//   Product(
		//     id: 'p3',
		//     title: 'Yellow Scarf',
		//     description: 'Warm and cozy - exactly what you need for the winter.',
		//     price: 19.99,
		//     imageUrl:
		//         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
		//   ),
		//   Product(
		//     id: 'p4',
		//     title: 'A Pan',
		//     description: 'Prepare any meal you want.',
		//     price: 49.99,
		//     imageUrl:
		//         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
		//   ),
	];

	List<Product> get items {
		return [..._items];
	}

	List<Product> get favoriteItems {
		return _items.where((prodItem) => prodItem.isFavorite).toList();
	}

	Product findById(String id) {
		return _items.firstWhere((prod) => prod.id == id);
	}

	Future<void> fetchAndSetProducts() async {
		const url =
				'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products.json';
		try {
			final response = await http.get(Uri.parse(url));
			final extractedData = json.decode(response.body) as Map<String, dynamic>;
			final List<Product> loadedProducts = [];
			extractedData.forEach((prodId, prodData) {
				//TUTAJ SPRAWDZIMY CZY PRODUKT JEST W ULUBIONYCH W FIREBASIE
				loadedProducts.add(Product(
					id: prodId,
					title: prodData['title'],
					description: prodData['description'],
					price: prodData['price'],
					isFavorite: false ,// I tutaj wstawimy tą informację           //prodData['isFavourite'],
					imageUrl: prodData['imageUrl'],
				));
			});
			_items = loadedProducts;
			notifyListeners();
		} catch (err) {
			rethrow;
		}
	}

	Future<void> addProduct(Product product) async {
		const url = 'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products.json';
		try {
			final response = await http.post(
				Uri.parse(url),
				
				body: json.encode({
					'title': product.title,
					'description': product.description,
					'imageUrl': product.imageUrl,
					'price': product.price,
					//'isFavourite': product.isFavorite
					})
			);
			final newProduct = Product(
				title: product.title,
				description: product.description,
				price: product.price,
				imageUrl: product.imageUrl,
				id: json.decode(response.body)['name'],
			);
			_items.add(newProduct);
			notifyListeners();
		} catch (error) {
			rethrow;
		}
	}

	Future<void> updateProduct(String id, Product newProduct) async {
		final prodIndex = _items.indexWhere((prod) => prod.id == id);
		if (prodIndex >= 0) {
			final url =
					'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products/$id.json';
			await http.patch(Uri.parse(url),
					body: json.encode({
						'title': newProduct.title,
						'description': newProduct.description,
						'imageUrl': newProduct.imageUrl,
						'price': newProduct.price,
						'isFavourite': newProduct.isFavorite
					}));
			_items[prodIndex] = newProduct;
			notifyListeners();
		} else {
			print('...');
		}
	}

	Future<void> deleteProduct(String id) async {
		final url =
				'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products/$id.json';
		final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
		Product? existingProduct = _items[existingProductIndex];
		_items.removeAt(existingProductIndex);
		notifyListeners();
		final response = await http.delete(Uri.parse(url));
		if (response.statusCode >= 400) {
			_items.insert(existingProductIndex, existingProduct);
			notifyListeners();
			throw HttpException('Could not delete product.');
		}
		existingProduct = null;
	}

	Future<void> updateFavourite(User user) async {
		final url = 'https://shop-app-9f7e6-default-rtdb.firebaseio.com/favourites/${user.uid}.json';
		try {
			final doWyslania = {};
			print(_items.where((prodItem) => prodItem.isFavorite).toList());
			for (var item in _items.where((prodItem) => prodItem.isFavorite).toList()) {
			  
			  doWyslania.putIfAbsent(item.id, () => true);
			}
			
			final response = await http.put(
				Uri.parse(url),
				body: json.encode(doWyslania)
			);
		
		} catch (error) {
			rethrow;
		}
	}


}
