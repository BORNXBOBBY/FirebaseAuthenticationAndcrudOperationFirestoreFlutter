import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'LoginPage.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({Key? key}) : super(key: key);

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {

  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text("Amazon"),
        backgroundColor: Colors.green,
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json'),
          ),
          const Text('Welcome My Home', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.red),)
        ],
      ),
    );
  }
}