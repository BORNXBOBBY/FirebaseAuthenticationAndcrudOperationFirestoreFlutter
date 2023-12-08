// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lottie/lottie.dart';
// import 'package:pinput/pinput.dart';
//
// import '../BottomNavigation.dart';
// import 'SendOtp.dart';
//
//
// class OtpPage extends StatefulWidget {
//   const OtpPage({Key? key}) : super(key: key);
//
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State<OtpPage> {
//   TextEditingController pinController = TextEditingController();
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 50 ),
//                 child: const Image(image: NetworkImage('https://cdni.iconscout.com/illustration/premium/thumb/otp-verification-5152137-4309037.png')),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Pinput(
//                   keyboardType: TextInputType.number,
//                   controller: pinController,
//                   length: 6,
//                   showCursor: true,
//                   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                   textInputAction: TextInputAction.next,
//                 ),
//               ),
//               Padding(
//                   padding: const EdgeInsets.only(top: 30),
//                   child: SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                                 verificationId: PhoneNumber.verify,
//                                 smsCode: pinController.text);
//                             // Sign the user in (or link) with the credential
//                             await auth.signInWithCredential(credential);
//                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BottomNavigation()));
//                             Fluttertoast.showToast(msg: "Login successful");
//                           } catch (e) {
//                             Fluttertoast.showToast(msg: "Enter Valid OTP");
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green, side: BorderSide.none, shape: StadiumBorder()),
//                         child: const Text("Please Enter Otp")),
//                   )
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import '../BottomNavigation.dart';
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
              Padding(
                padding: const EdgeInsets.only(top: 50 ),
                child: const Image(image: NetworkImage('https://cdni.iconscout.com/illustration/premium/thumb/otp-verification-5152137-4309037.png')),
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
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                verificationId: PhoneNumber.verify,
                                smsCode: pinController.text);
                            // Sign the user in (or link) with the credential
                            await auth.signInWithCredential(credential);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BottomNavigation()));
                            Fluttertoast.showToast(msg: "Login successful");
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Enter Valid OTP");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, side: BorderSide.none, shape: StadiumBorder()),
                        child: const Text("Please Enter Otp")),
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}