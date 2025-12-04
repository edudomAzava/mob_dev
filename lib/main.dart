
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'models/favorite_manager.dart'; 
import 'screens/home_screen.dart';
import 'screens/favorite_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider( 
      create: (context) => FavoriteManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multi-Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        FavoriteScreen.routeName: (context) => FavoriteScreen(), 
      },
    );
  }
}