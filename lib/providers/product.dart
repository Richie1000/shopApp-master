import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  void toggleFavouriteStatus(String authToken, String userId  ) async {
    final oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://shop-app-d00fc-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(url,
          body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        _setFavValue(oldFavourite);
      }
    } catch (error) {
      isFavourite = oldFavourite;
      notifyListeners();
    }
  }
}
