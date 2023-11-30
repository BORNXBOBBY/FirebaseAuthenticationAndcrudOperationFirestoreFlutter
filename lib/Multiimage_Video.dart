// OLNY MULTIPLE IMAGE SELECT AND UPLOAD IN FIREBASE

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageVideo extends StatefulWidget {
  const MultiImageVideo({Key? key}) : super(key: key);

  @override
  State<MultiImageVideo> createState() => _MultiImageVideoState();
}

class _MultiImageVideoState extends State<MultiImageVideo> {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final CollectionReference _items = FirebaseFirestore.instance.collection('MultiImageVideo');

  List<File> _images = [];

  Future<void> getImageGallery() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage( );

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((XFile file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    for (File image in _images) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique name for each image
      Reference ref = _storage.ref().child('multi_image_video/$imageName.jpg');
      UploadTask uploadTask = ref.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Now you can save the downloadURL to Firebase Firestore or perform any other necessary action
      await _items.add({'imageURL': downloadURL});

    }
    // Show a toast message
    Fluttertoast.showToast(
        msg: "Data successfully registered in Firebase",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 7);

    // Clear the images list after uploading
    setState(() {
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Multiple Image Video upload"),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: _images.isNotEmpty
                    ? Image.file(_images.first)
                    : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _images.isNotEmpty ? _uploadImages : null,
              child: Text("Upload"),
            ),
          )
        ],
      ),
    );
  }
}



// BOTH MULTIPLE IMAGE AND VIDEO SELECT AND UPLOAD IN FIREBASE

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
// class _MultiImageVideoState extends State<MultiImageVideo> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final ImagePicker _picker = ImagePicker();
//   final CollectionReference _items = FirebaseFirestore.instance.collection('MultiImageVideo');
//
//   List<File> _images = [];
//   File? _video;
//
//   Future<void> getImageGallery() async {
//     List<XFile>? pickedFiles = await _picker.pickMultiImage();
//
//     if (pickedFiles != null) {
//       setState(() {
//         _images = pickedFiles.map((XFile file) => File(file.path)).toList();
//         _video = null; // Reset selected video when images are selected
//       });
//     } else {
//       // If no images are selected, try picking a video
//       XFile? pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
//
//       if (pickedVideo != null) {
//         setState(() {
//           _video = File(pickedVideo.path);
//           _images.clear(); // Reset selected images when a video is selected
//         });
//       }
//     }
//   }
//
//   Future<void> _uploadImages() async {
//     // Implement your image upload logic here
//
//     for (File image in _images) {
//       String imageName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference ref = _storage.ref().child('multi_image_video/$imageName.jpg');
//       UploadTask uploadTask = ref.putFile(image);
//
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//
//       String downloadURL = await taskSnapshot.ref.getDownloadURL();
//
//       await _items.add({'imageURL': downloadURL});
//     }
//   }
//
//   Future<void> _uploadVideo() async {
//     // Implement your video upload logic here
//
//     if (_video != null) {
//       String videoName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference ref = _storage.ref().child('multi_image_video/$videoName.mp4');
//       UploadTask uploadTask = ref.putFile(_video!);
//
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//
//       String downloadURL = await taskSnapshot.ref.getDownloadURL();
//
//       await _items.add({'videoURL': downloadURL});
//     }
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
//                     : _video != null
//                     ? Icon(Icons.video_collection)
//                     : Center(child: Icon(Icons.image)),
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             margin: EdgeInsets.all(20),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_images.isNotEmpty) {
//                   _uploadImages();
//                 } else if (_video != null) {
//                   _uploadVideo();
//                 }
//                 // Show a toast message
//                 Fluttertoast.showToast(
//                   msg: "Data successfully registered in Firebase",
//                   backgroundColor: Colors.blueGrey,
//                   timeInSecForIosWeb: 7,
//                 );
//                 // Clear the images and video after uploading
//                 setState(() {
//                   _images.clear();
//                   _video = null;
//                 });
//               },
//               child: Text("Upload"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }