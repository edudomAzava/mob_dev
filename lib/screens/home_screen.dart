
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../models/product.dart';
import 'favorite_screen.dart';
import '../models/favorite_manager.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

 
  final List<Product> _products = [
    Product(
        id: '1',
        name: 'Товар 1',
        price: 10.99,
        imageUrl: ''), 
    Product(
        id: '2',
        name: 'Товар 2',
        price: 15.49,
        imageUrl: ''),
    Product(
        id: '3',
        name: 'Товар 3',
        price: 20.00,
        imageUrl: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: GridView.builder( 
        padding: const EdgeInsets.all(8.0),
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7, 
        ),
        itemBuilder: (context, index) {
          var product = _products[index];
          return ProductCard(product: product); 
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FavoriteScreen.routeName);
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context); 
    final isFav = favoriteManager.isFavorite(product.id);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded( // нах я это сделал, всё равно изображения не буду добавлять
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('4.5', style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Icon(
                        Icons.favorite,
                        color: isFav ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}