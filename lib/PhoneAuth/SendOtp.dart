import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lottie/lottie.dart';

import '../Account.dart';
import '../LoginPage.dart';
import 'VerifyOtp.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<bool> isPhoneUnique(String phone) async {
    // Check if the phone number already exists in Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .where('phone', isEqualTo: phone)
        .get();
    return snapshot.docs.isEmpty; // If docs are empty, phone is unique

  }



  Future<void> codeSent(String verificationId, int? resendToken) async {
    PhoneNumber.verify = verificationId;
    // Store verificationId in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('verificationId', verificationId);

    // Check if the user is logged in, if so, go to the Account page, else go to the Login page
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OtpPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
    Fluttertoast.showToast(msg: "Sent OTP");
  }


Future<String?> getStoredVerificationId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('verificationId');
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          const Image(
            image: NetworkImage(
                'https://cdni.iconscout.com/illustration/premium/thumb/man-using-mobile-phone-2839467-2371260.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), // Limit input to 10 characters
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                labelText: "Enter your Phone Number",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null // Disable button when loading
                    : () async {
                  setState(() {
                    isLoading = true; // Start loading
                  });
                  try {
                    bool isUnique = await isPhoneUnique(
                        '+91${phoneController.text}');
                    if (isUnique) {
                      // Proceed with sending OTP
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+91${phoneController.text}',
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          PhoneNumber.verify = verificationId;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const OtpPage()),
                          );
                          Fluttertoast.showToast(msg: "Sent OTP");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Phone number already exists!");
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: "OTP Failed");
                  } finally {
                    setState(() {
                      isLoading = false; // Stop loading
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  side: BorderSide.none,
                  shape: StadiumBorder(),
                ),
                child: isLoading
                    ? CircularProgressIndicator() // Show loader when loading
                    : const Text("Send Otp"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
