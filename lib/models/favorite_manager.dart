import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoriteManager with ChangeNotifier {
  final List<Product> _favoriteItems = [];

  List<Product> get favoriteItems => _favoriteItems;

  bool isFavorite(String productId) {
    return _favoriteItems.any((product) => product.id == productId);
  }

  void addFavorite(Product product) {
    if (!_favoriteItems.contains(product)) {
      _favoriteItems.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(String productId) {
    _favoriteItems.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFavorite(product.id);
    } else {
      addFavorite(product);
    }
  }

  void clearAllFavorites() {
    _favoriteItems.clear();
    notifyListeners();
  }
}