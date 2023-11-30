// // OLNY MULTIPLE IMAGE SELECT AND UPLOAD IN FIREBASE
//
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
//
// class MultiImageVideo extends StatefulWidget {
//   const MultiImageVideo({Key? key}) : super(key: key);
//
//   @override
//   State<MultiImageVideo> createState() => _MultiImageVideoState();
// }
//
// class _MultiImageVideoState extends State<MultiImageVideo> {
//
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final ImagePicker _picker = ImagePicker();
//   final CollectionReference _items = FirebaseFirestore.instance.collection('MultiImageVideo');
//
//   List<File> _images = [];
//
//   Future<void> getImageGallery() async {
//     List<XFile>? pickedFiles = await _picker.pickMultiImage( );
//
//     if (pickedFiles != null) {
//       setState(() {
//         _images = pickedFiles.map((XFile file) => File(file.path)).toList();
//       });
//     }
//   }
//
//   Future<void> _uploadImages() async {
//     for (File image in _images) {
//       String imageName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique name for each image
//       Reference ref = _storage.ref().child('multi_image_video/$imageName.jpg');
//       UploadTask uploadTask = ref.putFile(image);
//
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//
//       String downloadURL = await taskSnapshot.ref.getDownloadURL();
//
//       // Now you can save the downloadURL to Firebase Firestore or perform any other necessary action
//       await _items.add({'imageURL': downloadURL});
//
//     }
//     // Show a toast message
//     Fluttertoast.showToast(
//         msg: "Data successfully registered in Firebase",
//         backgroundColor: Colors.blueGrey,
//         timeInSecForIosWeb: 7);
//
//     // Clear the images list after uploading
//     setState(() {
//       _images.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text("Multiple Image Video upload"),
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: InkWell(
//               onTap: () {
//                 getImageGallery();
//               },
//               child: Container(
//                 margin: EdgeInsets.all(20),
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black,
//                   ),
//                 ),
//                 child: _images.isNotEmpty
//                     ? Image.file(_images.first)
//                     : Center(child: Icon(Icons.image)),
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             margin: EdgeInsets.all(20),
//             child: ElevatedButton(
//               onPressed: _images.isNotEmpty ? _uploadImages : null,
//               child: Text("Upload"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
//
