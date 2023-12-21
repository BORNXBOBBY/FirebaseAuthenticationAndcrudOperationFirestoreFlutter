import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigation.dart';
import 'EditProfile.dart';
import 'PhoneAuth/SendOtp.dart';
import 'SignUpPage.dart';
// import 'auth/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
bool isLoading = false; // Track loading state

class _LoginPageState extends State<LoginPage> {

  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();
  bool isLoading = false; // Track loading state




  void userLogin() async {
    setState(() {
      isLoading = true; // Start loading state
    });

    try {
      var mAuth = FirebaseAuth.instance;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailLoginController.text,
        password: passwordLoginController.text,
      ).then((value) async {
        // If sign-in is successful
        Fluttertoast.showToast(
          msg: "Login successful",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );

        // Store the user document ID in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userDocId', value.user?.uid ?? '');
        prefs.setBool('isPhone', false);

        // Navigate to the 'dashboard' route
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
        );
      }).catchError((error) {
        // If there's an error during sign-in
        print("Error: ${error.toString()}");
        Fluttertoast.showToast(
          msg: "${error.toString()}",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );
      });
    } catch (e) {
      // Handle errors during user registration
      print("Error during sign in: $e");
      Fluttertoast.showToast(
        msg: "Sign in failed. Please try again.",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 5,
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 50, bottom: 5),
              child: Text(
                'Email',
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
                    // controller: user_email,

                    controller: emailLoginController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
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
                'Password',
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
                    // controller: user_password,

                    controller: passwordLoginController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your password",
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
              padding: const EdgeInsets.only(left: 220, top: 10),
              child: TextButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ForgotPassword(),
                    //     ));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),

          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      primary: Colors.white,
                      shape: StadiumBorder()),
                onPressed: isLoading
                    ? null // Disable button when loading
                    : () {
                  userLogin();
                },
                child: isLoading
                    ? CircularProgressIndicator() // Show loader when loading
                    : Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Center(
                  child: Text(
                    '- OR -',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Container(
              child: Center(
                  child: Text(
                    'Sign In with',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 40, top: 25),
                  child: Container(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginForm(),));
                        },
                        child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/2111/2111393.png')),
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {

                          _handleGoogleSignIn();
                        },
                        child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/281/281764.png')),
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 25),
                  child: Container(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneNumber(),));
                        },
                        child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/3437/3437364.png')),
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ),
                ),
              ],
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
                      "Don't have an Account?",
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
                                builder: (context) => Regester(),
                              ));
                        },
                        child: Text(" Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser
  //       ?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BottomNavigation(),));
  //   return userCredential;
  //
  // }
  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.setBool('isPhone', false);

        Fluttertoast.showToast(
          msg: "Google Login successful",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );

        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()) );
      } else {
        Fluttertoast.showToast(
          msg: "Google Login failed",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Google Login Failed",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 5,
      );
    }
  }
}