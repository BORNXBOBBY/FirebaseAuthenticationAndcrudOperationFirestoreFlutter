import 'package:google_auth_flutter/BottomNavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_auth_flutter/widgets/CustomElevatedButton.dart';
import 'BottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false; // Track loading state

  Future<void> validate() async {
    if (name.text.length <= 3) {
      Fluttertoast.showToast(msg: 'Invalid Name');
    } else if (!email.text.contains('@gmail.com')) {
      Fluttertoast.showToast(msg: 'Invalid Email');
    } else if (phone.text.length < 10) {
      Fluttertoast.showToast(msg: 'Enter a valid 10 digit phone number');
    } else if (address.text.length <= 5) {
      Fluttertoast.showToast(msg: 'Please fill your current address');
    } else if (password.text.length < 8) {
      Fluttertoast.showToast(msg: 'Password should have at least 8 characters');
    } else {
      await checkIfPhoneExists(context);
    }
  }

  // / Function to check if the phone number is already registered
  Future<void> checkIfPhoneExists(BuildContext context) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone.text)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is already registered');
    } else {
      await firebaseAuth(context);
    }
  }

  Future<void> firebaseAuth(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      if (userCredential.user != null) {
        await userData(userCredential.user!.uid);
        // Navigate to the next screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email is already registered');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }



  // firebaseAuth() {
  //   FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //       email: email.text, password: password.text)
  //       .then((value) {
  //     Fluttertoast.showToast(msg: "Register Successful");
  //     userData(value.user?.uid); // Pass the UID to userData
  //   });
  // }

  userData(String? uid) async {
    final userData = {
      "id": uid, // Set UID as ID field
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "address": address.text,
      "password": password.text,
    };

    FirebaseFirestore.instance.collection("users").doc(uid).set(userData).then((value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userDocId', uid ?? ''); // Save the document ID to SharedPreferences

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(),
        ),
      );
    });
  }
  Future<String?> getStoredDocId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDocId = prefs.getString('userDocId');
    return storedDocId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 50, top: 50, bottom: 5),
            child: Text(
              'Full Name *',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: SizedBox(
              height: 65,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white54,
                shadowColor: Colors.black,
                elevation: 10,

                child: TextField(
                  //email authentication
                  controller: name,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter your name",
                      border: InputBorder.none,
                      iconColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      hintStyle:
                      TextStyle(color: Colors.white70, fontSize: 18),
                      // prefixIcon: Icon(Icons.person,),
                      prefixIconColor: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Email *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter your email",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Mobile No *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter your Mobile No.",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Current Address *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: address,
                    keyboardType: TextInputType.streetAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_location_alt),
                        hintText: "Enter your address",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Create Password *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your Password",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 30),
              child: CustomElevatedButton(
                elevation: 10,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                primary: Colors.white,
                shape: StadiumBorder(),
                onPressed: isLoading ? null : () {
                  validate();
                },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                  'SUBMIT',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "If you have an Account?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(" Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}