 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_manager.dart'; 
import '../models/product.dart'; 
import 'details_screen.dart';


final List<Product> _allProducts = [
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

class FavoriteScreen extends StatelessWidget {
  static const routeName = '/favorite';

  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context); 
    final favoriteIds = favoriteManager.favorites; 


    final favoriteProducts = _allProducts
        .where((product) => favoriteIds.contains(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Избранных товаров нет',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder( 
              padding: const EdgeInsets.all(8.0),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                var product = favoriteProducts[index];
                return Dismissible( // свайп для удаления
                  key: Key(product.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    favoriteManager.toggleFavorite(product.id); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} удалён из избранного')),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: Card(
                    child: ListTile(
                      leading: Hero( // Hero-анимация
                        tag: product.id,
                        child: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}