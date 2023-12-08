import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_auth_flutter/BottomNavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Home.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {
  User? _user;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Future getImageGallery() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }
  Future getImageCamera() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Future<void> _updateUserProfile() async {
    if (_user != null) {
      try {
        if (_image != null) {
          // Upload the image to Firebase Storage
          await _uploadImageToFirebaseStorage();

          // Get the download URL of the uploaded image
          String imageUrl = await FirebaseStorage.instance
              .ref()
              .child("user_images/${_user!.uid}")
              .getDownloadURL();
          await _user!.updatePhotoURL(imageUrl);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully!"),
          ),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
          ),
        );
      }
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (_image != null) {
      try {
        final storage = FirebaseStorage.instance;
        final Reference storageReference =
        storage.ref().child("user_images/${_user!.uid}");
        await storageReference.putFile(_image!);
        String imageUrl = await storageReference.getDownloadURL();
        print("Image uploaded to Firebase Storage: $imageUrl");
      } catch (e) {
        print("Error uploading image to Firebase Storage: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null && _user!.photoURL != null)
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  onDoubleTap: (){
                    getImageCamera();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(
                      child: Image.network(
                        _user!.photoURL!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            if (_user != null && _user!.email != null)
              Container(
                margin: const EdgeInsets.fromLTRB(15,100,15,15),
                child: TextField(
                  onChanged: (newEmail) {},
                  decoration: InputDecoration(
                    hintText: _user!.email!,
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Background color
                  onPrimary: Colors.white, // Text color
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   User? _user;
//   File? _image;
//   final picker = ImagePicker();
//   Map<String, dynamic>? _userData;
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((event) async {
//       setState(() {
//         _user = event;
//       });
//       if (_user != null) {
//         await fetchUserData(_user!.uid);
//       }
//     });
//   }
//
//   Future<void> fetchUserData(String uid) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> snapshot =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       setState(() {
//         _userData = snapshot.data();
//         // Pre-fill the form fields with existing data
//         _nameController.text = _userData?['name'] ?? '';
//         _phoneController.text = _userData?['phone'] ?? '';
//         _addressController.text = _userData?['address'] ?? '';
//       });
//     } catch (e) {
//       print('Error fetching user data: $e');
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
//
//           // Update user data including the profile picture URL
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(_user!.uid)
//               .update({
//             'name': _nameController.text,
//             'phone': _phoneController.text,
//             'address': _addressController.text,
//             // Add more fields as needed
//           });
//
//           // Update the user's profile picture URL
//           await _user!.updatePhotoURL(imageUrl);
//         } else {
//           // If no image is selected, update only user data
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(_user!.uid)
//               .update({
//             'name': _nameController.text,
//             'phone': _phoneController.text,
//             'address': _addressController.text,
//             // Add more fields as needed
//           });
//         }
//
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
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
//                   onDoubleTap: () {
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
//                         ? Image.file(_image!)
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
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   TextFormField(
//                     controller: _phoneController,
//                     decoration: InputDecoration(
//                       labelText: 'Phone',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: InputDecoration(
//                       labelText: 'Address',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _updateUserProfile,
//                     child: Text('Save Changes'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
