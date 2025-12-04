import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_manager.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  DateTime? _lastSwipeTime;
  int _swipeCount = 0;
  static const Duration _swipeTimeout = Duration(milliseconds: 500); 
  static const int _requiredSwipes = 2; 
  static const double _minVelocity = 300.0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx < -_minVelocity) { 
            final now = DateTime.now();
            if (_lastSwipeTime == null || now.difference(_lastSwipeTime!) > _swipeTimeout) {
              _swipeCount = 1;
            } else {
              _swipeCount++;
            }
            _lastSwipeTime = now;

            if (_swipeCount >= _requiredSwipes) {
              _confirmAndClearFavorites();
              _swipeCount = 0; 
              _lastSwipeTime = null;
            }
          } else if (details.velocity.pixelsPerSecond.dx > _minVelocity) { 
             _swipeCount = 0;
             _lastSwipeTime = null;
          }
        },
        child: Consumer<FavoriteManager>(
          builder: (context, favoriteManager, child) {
            final favoriteItems = favoriteManager.favoriteItems;

            if (favoriteItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, size: 100, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'Ваш список избранного пуст.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Свайпните дважды влево, чтобы очистить (если список не пуст).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                var product = favoriteItems[index];
                return Dismissible( 
                  key: Key(product.id),
                  onDismissed: (direction) {
                    favoriteManager.removeFavorite(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Товар "${product.name}" удален из избранного.')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        favoriteManager.removeFavorite(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Товар "${product.name}" удален из избранного.')),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmAndClearFavorites() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Очистить избранное?'),
          content: Text('Вы уверены, что хотите удалить все товары из избранного?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoriteManager>().clearAllFavorites(); 
                Navigator.of(context).pop(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Список избранного очищен.')),
                );
              },
              child: Text('Очистить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}