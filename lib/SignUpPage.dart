import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../widgets/rounded_btn.dart';
import 'LoginPage.dart';

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
  final formKey =GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('UserProfileData');
  String? _userDocId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Register Page'),

        ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 30.0), // Customize padding
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text("Let's Get Started",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF625A5A),
                              )),
                        ),
                        Container(
                          child: Text(
                            'Create an account',
                            style: TextStyle(color: Color(0xFF0D4619)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      prefixIcon: Icon(Icons.person),
                      border:
                      OutlineInputBorder(), // Add this line for a border
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name cannot be empty";
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Name must contain at least one uppercase letter";
                      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Name must contain at least one lowercase letter";
                      } else {
                        return null; // Validation passed
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Your Email",
                      prefixIcon: Icon(Icons.email),
                      border:
                      OutlineInputBorder(), // Add this line for a border
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty";
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                        return "Please enter a valid email address";
                      } else {
                        return null; // Validation passed
                      }
                    },

                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixIcon: Icon(Icons.phone),
                      prefixText: "+91 ",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number cannot be empty.';
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit mobile number.';
                      } else {
                        return null; // Validation passed
                      }
                    },
                  ),
                ),


                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Password must contain at least one uppercase letter";
                      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Password must contain at least one lowercase letter";
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Password must contain at least one digit";
                      } else if (!RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]').hasMatch(value)) {
                        return "Password must contain at least one special character";
                      } else {
                        return null; // Validation passed
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                  Container(
                    // width: MediaQuery.of(context).size.width ,
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.only(top: 20),
                    child: RoundedButton(
                      btnName: "Sign Up",
                      callback: () async {
                        if (formKey.currentState!.validate()) {
                          // Form validation passed, perform registration
                          await Firebase.initializeApp(); // Initialize Firebase

                          try {

                            UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString(),
                            ).whenComplete(() async {  //
                              // Check if the email is already in use
                              QuerySnapshot emailQuery = await _items.where("email", isEqualTo: emailController.text).get();
                              // Check if the mobile number is already in use
                              QuerySnapshot mobileQuery = await _items.where("mobile", isEqualTo: mobileController.text).get();

                              if (emailQuery.docs.isNotEmpty && mobileQuery.docs.isNotEmpty) {
                                // Both email and mobile number are already in use

                                Fluttertoast.showToast(
                                  msg: "Both email and mobile number are already in use.",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );
                                return; // Stop execution if both email and mobile are already in use
                              }

                              if (emailQuery.docs.isNotEmpty) {
                                // Email is already in use

                                Fluttertoast.showToast(
                                  msg: "Email is already in use",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );
                                return; // Stop execution if email is already in use
                              }

                              if (mobileQuery.docs.isNotEmpty) {
                                // Mobile number is already in use

                                Fluttertoast.showToast(
                                  msg: "Mobile number is already in use. Please use a different mobile number.",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );

                                // Stop execution if mobile number is already in use


                              }

                              else{
                                // Registration successful
                                final String name = nameController.text;
                                final String email = emailController.text;
                                final String mobile = mobileController.text;
                                final String password = passwordController.text;

                                // Get the user ID
                                String userId = auth.currentUser?.uid ?? "";

                                // Add user details to Firestore or any other database
                                await _items.doc(userId).set({
                                  "name": name,
                                  "email": email,
                                  "mobile": mobile,
                                  "password": password,
                                  "userId": userId,
                                });

                                // Store the document ID in shared preferences
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('userDocId', userId);


                                // Store the document ID in _userDocId
                                _userDocId = userId;
                              }

                            });


                            // Clear text fields after successful registration
                            nameController.text = '';
                            emailController.text = '';
                            mobileController.text = '';
                            passwordController.text = '';

                            // Print success message to the console
                            print("User created: ${userCredential.user?.uid}");
                            print("Registration successful!");

                            // Show a toast message
                            Fluttertoast.showToast(
                              msg: "Registration successful",
                              backgroundColor: Colors.blueGrey,
                              timeInSecForIosWeb: 5,
                            );

                            // Navigate to the dashboard
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoard()));
                          } catch (e) {
                            print("Error during sign up: $e");

                            // Handle specific error cases

                          }
                        }
                      },
                      bgColor: Color(0xFF0D4619),
                      textStyle: TextStyle(fontFamily: AutofillHints.givenName),
                    ),

                  ),

                ]),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the children horizontally
                        children: [
                          Container(
                            child: Text(
                              "Have an acount?",
                            ),
                          ),
                          Container(
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => LoginPage(), ));},
                                child: Text(
                                  " Sign In ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}