
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../models/product.dart';
import '../models/favorite_manager.dart'; 

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context); 
    final isFav = favoriteManager.isFavorite(product.id); 
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero( 
              tag: product.id, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  height: 200, 
                  width: double.infinity, 
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('ID: ${product.id}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    )),
            const SizedBox(height: 8),
            Text(product.name,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.green,
                    )),
            const SizedBox(height: 16),
            Text('Дополнительное описание товара...',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          favoriteManager.toggleFavorite(product.id); 
          String message = favoriteManager.isFavorite(product.id)
              ? 'Добавлено в избранное!'
              : 'Удалено из избранного!';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
        child: Icon(isFav ? Icons.favorite : Icons.favorite_border),
        backgroundColor: isFav ? Colors.red : null,
      ),
    );
  }
}