import 'package:flutter/material.dart';
import 'package:trendycart_of_seller/features/dashboard/dashboard.dart';
import 'package:trendycart_of_seller/features/dashboard/orderScreen.dart';
import 'package:trendycart_of_seller/features/dashboard/product.dart';
import 'package:trendycart_of_seller/features/dashboard/profile-screen.dart';
import 'package:trendycart_of_seller/features/dashboard/review_screen.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Product",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: "Feedback",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Profile",
          ),
        ],
      ),
    );
  }

  List<Widget> items = [
    DashboardScreen(),
    OrdersPage(),
    ProductScreen(),

    ReviewScreen(),
    ProfileScreen(),
  ];
}
