import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_auth_flutter/EditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('UserProfileData');

  User? _user;
  String? _userName;
  String? _userEmail;
  String? _userMobile;
  String? _docId;
  final auth = FirebaseAuth.instance;

  // Method to fetch user data
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedUid = prefs.getString('userDocId');
    bool? status = prefs.getBool('isPhone');
    final currentUser = auth.currentUser;
    String? phoneNumber = currentUser?.phoneNumber;
    String? email = currentUser?.email;

    if (currentUser != null) {
      try {
        DocumentSnapshot<Object?> snapshot;
        if (status ==null || status == false) {
          snapshot = await _items.where('email', isEqualTo: email).limit(1).get().then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
            } else {
              throw Exception("User data not found for phone number: $phoneNumber");
            }
          });

        } else {
          // If no stored document ID, try fetching based on phone number
          snapshot = await _items.where('mobile', isEqualTo: phoneNumber).limit(1).get().then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
            } else {
              throw Exception("User data not found for phone number: $phoneNumber");
            }
          });
        }

        if (snapshot.exists) {
          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              _userName = userData['name'];
              _userEmail = userData['email'];
              _userMobile = userData['mobile'];
              _docId = userData["userId"];
            });
          }
        } else {
          print("User data does not exist in Firestore");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }



  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });

      if (_user != null) {
        // Fetch user profile data from Firestore
        _fetchUserData();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Profile Page"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Center(
        child: _user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10),
            if (_userName != null) Text(_userName!),
            SizedBox(height: 10),
            if (_userEmail != null) Text(_userEmail!),
            SizedBox(height: 20),
            if (_userMobile != null) Text(_userMobile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button's background color
                onPrimary: Colors.white, // Set the text color
              ),
              child: Text("Edit Profile"),
            ),

          ],
        )
            : CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}