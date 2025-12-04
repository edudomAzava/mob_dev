import 'package:flutter/foundation.dart';
import 'product.dart';

class FavoriteManager extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  //получение списка избранных продуктов
  Set<String> getFavoriteIds() {
    return _favorites.toSet();
  }
}