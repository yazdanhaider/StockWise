import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/wishlist_screen.dart';
import 'models/stock_model.dart';
import 'services/api_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockModel()),
        Provider(create: (_) => ApiService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainWrapper(),
      title: 'StockWise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    WishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Colors.deepPurple.shade600,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              _buildNavigationBarItem(Icons.home_filled, 'Home'),
              _buildNavigationBarItem(Icons.favorite_sharp, 'Wishlist'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
        decoration: BoxDecoration(
          color: _currentIndex == (label == 'Home' ? 0 : 1) ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}