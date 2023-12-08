import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Account'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_user != null && _user!.photoURL != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_user!.photoURL!),
                ),
              SizedBox(height: 15),
              if (_user != null && _user!.email != null)
                Text('Email: ${_user!.email}'),
              SizedBox(height: 15),
              // Placeholder text for name, phone, and address
              if (_userData != null)
                Column(
                  children: [
                    Text('Name: ${_userData!['name'] ?? 'No name'}'),
                    Text('Phone: ${_userData!['phone'] ?? 'No phone'}'),
                    Text('Address: ${_userData!['address'] ?? 'No address'}'),
                  ],
                ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
