import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/favorite_manager.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteManager>( 
      builder: (context, favoriteManager, child) {
        bool _isFavorite = favoriteManager.isFavorite(product.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            automaticallyImplyLeading: true, 
          ),
          body: GestureDetector( 
            onDoubleTap: () { 
              favoriteManager.toggleFavorite(product);
              String message = _isFavorite ? 'Удалено из избранного!' : 'Добавлено в избранное!';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${product.id}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Название: ${product.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Цена: \$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  Text('Совет: Дважды тапните по экрану, чтобы быстро добавить/удалить из избранного.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              favoriteManager.toggleFavorite(product);
              String message = favoriteManager.isFavorite(product.id) ? 'Добавлено в избранное!' : 'Удалено из избранного!';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            child: Icon(favoriteManager.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
            backgroundColor: favoriteManager.isFavorite(product.id) ? Colors.red : null,
          ),
        );
      },
    );
  }
}