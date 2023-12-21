
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_auth_flutter/BottomNavigation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/rounded_btn.dart';

class PhoneRegister extends StatefulWidget {

  const PhoneRegister({Key? key}) : super(key: key);

  @override
  State<PhoneRegister> createState() => _PhoneRegisterState();
}

class _PhoneRegisterState extends State<PhoneRegister> {
  final auth = FirebaseAuth.instance.currentUser;
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('UserProfileData');

  final phoneNameController = TextEditingController();
  final phoneEmailController = TextEditingController();
  final phoneMobileController = TextEditingController();

  @override
  void initState() {
    phoneMobileController.text = auth!.phoneNumber!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("User Account"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 70),
                child: TextFormField(
                  controller: phoneNameController,
                  decoration: InputDecoration(
                    labelText: "Your Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextFormField(
                  controller: phoneEmailController,
                  decoration: InputDecoration(
                    labelText: "Your Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),

                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child: TextFormField(
                  controller: phoneMobileController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Your Conctact",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),

                ),
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                child: RoundedButton(
                  btnName: "Sign Up",
                  callback: () async {
                    try {
                      await Firebase.initializeApp(); // Initialize Firebase

                      User? user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        // User is not signed in
                        print('User is not signed in.');
                        return;
                      }

                      String userId = user.uid; // Get the current user UID

                      // Registration successful
                      final String phoneName = phoneNameController.text;
                      final String phoneEmail = phoneEmailController.text;
                      final String phoneMobile = phoneMobileController.text;

                      // Add user details to Firestore
                      await _items.doc(userId).set({
                        "name": phoneName,
                        "email": phoneEmail,
                        "mobile": phoneMobile,
                        "userId":userId
                      });

                      // Store the UID in shared preferences
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setString('userDocId', userId);

                      // Clear text fields after successful registration
                      phoneNameController.text = '';
                      phoneEmailController.text = '';
                      phoneMobileController.text = '';

                      // Print success message to the console
                      print("User created: $userId");
                      print("Registration successful!");

                      // Show a toast message
                      Fluttertoast.showToast(
                        msg: "Registration successful",
                        backgroundColor: Colors.blueGrey,
                        timeInSecForIosWeb: 5,
                      );
                      prefs.setBool('isPhone', true);

                      // Navigate to the dashboard
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigation()),
                      ); // Replace with your Dashboard class
                    } catch (e) {
                      print("Error during sign up: $e");

                      // Handle specific error cases
                      if (e is FirebaseAuthException) {
                        if (e.code == 'email-already-in-use') {
                          // The email address is already in use by another account.
                          print("Email is already in use.");
                          // Show a toast message or handle the case as needed
                          Fluttertoast.showToast(
                            msg:
                            "Email is already in use. Please use a different email.",
                            backgroundColor: Colors.red,
                            timeInSecForIosWeb: 5,
                          );
                        } else {
                          // Handle other FirebaseAuthException cases as needed
                          print("FirebaseAuthException: ${e.code}");
                        }
                      } else {
                        // Handle other exceptions
                        print("Unexpected error during sign up: $e");
                      }
                    }
                  },
                  bgColor: Color(0xFF0D4619),
                  textStyle: TextStyle(fontFamily: AutofillHints.givenName),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}