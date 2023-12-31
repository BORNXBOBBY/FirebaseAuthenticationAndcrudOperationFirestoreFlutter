import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_auth_flutter/SignUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import '../BottomNavigation.dart';
import '../PhoneSignUp.dart';
import 'SendOtp.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController pinController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your UI elements here
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: const Image(
                    image: NetworkImage(
                        'https://cdni.iconscout.com/illustration/premium/thumb/otp-verification-5152137-4309037.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Pinput(
                  keyboardType: TextInputType.number,
                  controller: pinController,
                  length: 6,
                  showCursor: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {

                        PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId: PhoneNumber.verify,
                          smsCode: pinController.text,
                        );

                        UserCredential userCredential =
                        await auth.signInWithCredential(credential);

                        // Check if the user is new or existing
                        if (userCredential.additionalUserInfo!.isNewUser) {
                          // New user, navigate to signup page
                          // Replace 'SignupPage()' with your actual signup page class
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneRegister(),
                            ),
                          );
                        } else {
                          // Existing user, navigate to home page
                          // Replace 'BottomNavigation()' with your actual home page class
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigation(),
                            ),
                          );
                        }

                        Fluttertoast.showToast(msg: "Login successful");
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Enter Valid OTP");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      side: BorderSide.none,
                      shape: StadiumBorder(),
                    ),
                    child: const Text("Please Enter Otp"),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}