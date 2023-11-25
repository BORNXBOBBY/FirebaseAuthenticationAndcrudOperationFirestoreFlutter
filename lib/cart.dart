import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CartBottomNav extends StatefulWidget {
  const CartBottomNav({Key? key}) : super(key: key);

  @override
  State<CartBottomNav> createState() => _CartBottomNavState();
}

class _CartBottomNavState extends State<CartBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Cart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json'),
          ),
          const Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
