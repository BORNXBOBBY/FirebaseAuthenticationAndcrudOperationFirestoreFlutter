import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import 'EditProfile.dart';

class AccountBottomNav extends StatefulWidget {
  const AccountBottomNav({Key? key});

  @override
  State<AccountBottomNav> createState() => _AccountBottomNavState();
}

class _AccountBottomNavState extends State<AccountBottomNav> {
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      setState(() {
        _user = event;
      });
      if (_user != null) {
        await fetchUserData(_user!.uid);
      }
    });
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userData = snapshot.data();
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Lottie.network(
                'https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json',
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_user != null && _user!.photoURL != null)
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(_user!.photoURL!),
                            ),
                          if (_user != null && _user!.email != null)
                            Text('Email: ${_user!.email}'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            if (_userData != null) ...[
                              ListTile(
                                title: Text('Name'),
                                subtitle: Text(_userData!['name'] ?? 'No name'),
                              ),
                              ListTile(
                                title: Text('Phone'),
                                subtitle: Text(_userData!['phone'] ?? 'No phone'),
                              ),
                              ListTile(
                                title: Text('Address'),
                                subtitle: Text(_userData!['address'] ?? 'No address'),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfile()),
                          );
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
