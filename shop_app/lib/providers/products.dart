import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get notFavoriteItems {
    return _items.where((prodItem) => !prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts(User? user) async {
    const url =
        'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw HttpException(
            'Could not load products...check your internet connection');
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var favData = {};
      if (user != null) {
        final favurl =
            'https://shop-app-9f7e6-default-rtdb.firebaseio.com/favourites/${user.uid}.json';
        final favresponse = await http.get(Uri.parse(favurl));
        favData = json.decode(favresponse.body) as Map<String, dynamic>;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        //TUTAJ SPRAWDZIMY CZY PRODUKT JEST W ULUBIONYCH W FIREBASIE
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: user == null
              ? false
              : favData.keys.contains(
                  prodId), // I tutaj wstawimy tą informację           //prodData['isFavourite'],
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
    const url =
        'https://shop-app-9f7e6-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            //'isFavourite': product.isFavorite
          }));
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
    final url =
        'https://shop-app-9f7e6-default-rtdb.firebaseio.com/favourites/${user.uid}.json';
    try {
      final doWyslania = {};
      print(_items.where((prodItem) => prodItem.isFavorite).toList());
      for (var item
          in _items.where((prodItem) => prodItem.isFavorite).toList()) {
        doWyslania.putIfAbsent(item.id, () => true);
      }

      final response =
          await http.put(Uri.parse(url), body: json.encode(doWyslania));
    } catch (error) {
      rethrow;
    }
  }
}
