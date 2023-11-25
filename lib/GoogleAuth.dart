import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_auth_flutter/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'LoginPage.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child:Center(
                child: SizedBox(
                  height: 50,
                  child: SignInButton(
                    onPressed: (){
                      _handleGoogleSignIn();

                    },
                    Buttons.google,text: "Sign up with google",),

                ),
              ),
            )
            // ElevatedButton(
            //   onPressed: _signOut,
            //   child: Text('Sign out'),
            // ),
          ],
        ),
      ),
    );
  }


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

        Fluttertoast.showToast(
          msg: "Google Login successful",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );

        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavigation()));
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