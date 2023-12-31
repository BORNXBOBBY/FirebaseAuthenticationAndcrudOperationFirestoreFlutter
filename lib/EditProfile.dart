// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_auth_flutter/BottomNavigation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// import 'Home.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
//
// class _EditProfileState extends State<EditProfile> {
//   User? _user;
//   File? _image;
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((event) {
//       setState(() {
//         _user = event;
//       });
//     });
//   }
//
//   Future getImageGallery() async {
//     final pickedFile =
//     await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("No Image Picked");
//       }
//     });
//   }
//   Future getImageCamera() async {
//     final pickedFile =
//     await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("No Image Picked");
//       }
//     });
//   }
//
//   Future<void> _updateUserProfile() async {
//     if (_user != null) {
//       try {
//         if (_image != null) {
//           // Upload the image to Firebase Storage
//           await _uploadImageToFirebaseStorage();
//
//           // Get the download URL of the uploaded image
//           String imageUrl = await FirebaseStorage.instance
//               .ref()
//               .child("user_images/${_user!.uid}")
//               .getDownloadURL();
//           await _user!.updatePhotoURL(imageUrl);
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Profile updated successfully!"),
//           ),
//         );
//       } catch (e) {
//         print("Error updating profile: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error updating profile: $e"),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _uploadImageToFirebaseStorage() async {
//     if (_image != null) {
//       try {
//         final storage = FirebaseStorage.instance;
//         final Reference storageReference =
//         storage.ref().child("user_images/${_user!.uid}");
//         await storageReference.putFile(_image!);
//         String imageUrl = await storageReference.getDownloadURL();
//         print("Image uploaded to Firebase Storage: $imageUrl");
//       } catch (e) {
//         print("Error uploading image to Firebase Storage: $e");
//       }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text("Edit Profile"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_user != null && _user!.photoURL != null)
//               Center(
//                 child: InkWell(
//                   onTap: () {
//                     getImageGallery();
//                   },
//                   onDoubleTap: (){
//                     getImageCamera();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.all(20),
//                     height: 100,
//                     width: 100,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                     ),
//                     child: _image != null
//                         ? Image.file(_image!.absolute)
//                         : Center(
//                       child: Image.network(
//                         _user!.photoURL!,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             if (_user != null && _user!.email != null)
//               Container(
//                 margin: const EdgeInsets.fromLTRB(15,100,15,15),
//                 child: TextField(
//                   onChanged: (newEmail) {},
//                   decoration: InputDecoration(
//                     hintText: _user!.email!,
//                   ),
//                 ),
//               ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(20),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await _updateUserProfile();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const BottomNavigation()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.green, // Background color
//                   onPrimary: Colors.white, // Text color
//                 ),
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(color: Colors.white), // Text color
//                 ),
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_auth_flutter/BottomNavigation.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  hintText: "Enter your mobile number",
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(15),
            //   child: TextField(
            //     controller: _passwordController,
            //     obscureText: true,
            //     onChanged: (newPassword) {
            //       // Handle the new password change
            //     },
            //     decoration: InputDecoration(
            //       hintText: "Enter your password",
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();

                },
                child: Text("Save Changes"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserProfile() async {

    User? user = FirebaseAuth.instance.currentUser;

    // Get the values from the controllers
    String newName = _nameController.text;
    String newMobile = _mobileController.text;
    // String newPassword = _passwordController.text;


    // Replace "userId" with the actual user ID or identifier
    String? userId = user?.uid;

    // Update the data in Firestore using the values newName, newMobile, and newPassword
    await FirebaseFirestore.instance.collection("UserProfileData").doc(userId).update({
      "name": newName,
      "mobile": newMobile,
      // "password": newPassword,
      "userId":userId
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigation()),
    );

  }
}