import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, HomeBottomNav() as String); // Navigates back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('purchased_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in the cart'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item = snapshot.data!.docs[index].data() as Map<String, dynamic>;



              return ListTile(
                leading: Image.network(

                  // ['products_image']?.toString() ?? '',
                  item['products_image'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['product_title'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${item['quantity'] ?? ''}'),
                    Text('Seller ID: ${item['seller_id'] ?? ''}'),
                    // Add other details as needed
                  ],
                ),
                // Add other necessary details
              );
            },

          );
        },
      ),
    );
  }
}