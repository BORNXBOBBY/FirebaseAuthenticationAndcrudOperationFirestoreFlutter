// // BOTH MULTIPLE IMAGE AND VIDEO SELECT AND UPLOAD IN FIREBASE

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
//       Reference ref = _storage.ref().child('multi_image_videoplayer/$imageName.jpg');
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
//       Reference ref = _storage.ref().child('multi_image_videoplayer/$videoName.mp4');
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

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//
// class VideoPickerWidget extends StatefulWidget {
//   @override
//   _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
// }
//
// class _VideoPickerWidgetState extends State<VideoPickerWidget> {
//   XFile? _video;
//   late VideoPlayerController _videoController;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool isPlaying = false;
//   bool isMuted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.file(File(_video?.path ?? ''))
//       ..addListener(() {
//         if (!mounted) return;
//         setState(() {});
//       });
//     _initializeVideoPlayerFuture = _videoController.initialize();
//   }
//
//   Future<void> _pickVideo() async {
//     XFile? pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
//
//     if (pickedVideo != null) {
//       setState(() {
//         _video = pickedVideo;
//         _videoController = VideoPlayerController.file(File(_video?.path ?? ''))
//           ..addListener(() {
//             if (!mounted) return;
//             setState(() {});
//           });
//         _initializeVideoPlayerFuture = _videoController.initialize();
//         _videoController.setLooping(true); // Optional: Enable looping
//       });
//     }
//   }
//
//   Future<void> _uploadVideoToFirebaseStorage() async {
//     if (_video != null) {
//       try {
//         File videoFile = File(_video!.path);
//
//         firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//             .ref()
//             .child('videos')
//             .child('video_${DateTime.now().millisecondsSinceEpoch}.mp4');
//
//         firebase_storage.UploadTask uploadTask = ref.putFile(videoFile);
//
//         firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
//
//         if (taskSnapshot.state == firebase_storage.TaskState.success) {
//           // The video has been successfully uploaded
//           String downloadUrl = await ref.getDownloadURL();
//           print('Video uploaded. Download URL: $downloadUrl');
//
//           // You can use the downloadUrl to access the uploaded video file
//         } else {
//           // Handle the error scenario
//           print('Failed to upload the video');
//         }
//       } catch (e) {
//         // Handle exceptions
//         print('Error uploading video: $e');
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Picker'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_video != null)
//                 AspectRatio(
//                   aspectRatio: _videoController.value.aspectRatio,
//                   child: VideoPlayer(_videoController),
//                 )
//               else
//                 const Text('No video selected'),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                     onPressed: () {
//                       setState(() {
//                         if (isPlaying) {
//                           _videoController.pause();
//                         } else {
//                           _videoController.play();
//                         }
//                         isPlaying = !isPlaying;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 16),
//                   IconButton(
//                     icon: Icon(Icons.stop),
//                     onPressed: () {
//                       setState(() {
//                         _videoController.pause();
//                         _videoController.seekTo(Duration.zero);
//                         isPlaying = false;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 16),
//                   IconButton(
//                     icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
//                     onPressed: () {
//                       setState(() {
//                         isMuted = !isMuted;
//                         _videoController.setVolume(isMuted ? 0.0 : 1.0);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: _pickVideo,
//                 child: const Text('Pick Video'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await _pickVideo();
//                   await _uploadVideoToFirebaseStorage();
//                 },
//                 child: const Text('Pick and Upload Video'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebseauthentication/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_auth_flutter/BottomNavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MultiImageVideo extends StatefulWidget {
  const MultiImageVideo({Key? key}) : super(key: key);

  @override
  State<MultiImageVideo> createState() => _MultiImageVideoState();
}

class _MultiImageVideoState extends State<MultiImageVideo> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('MultiImageVideo');

  List<File> _images = [];
  List<File> _videos = [];
  XFile? _video;
  bool isPlaying = false;
  bool isMuted = false;
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  Future<void> getImageGallery() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((XFile file) => File(file.path)).toList();
      });
    }
  }

  Future<void> getVideoGallery() async {
    XFile? pickedVideo = (await _picker.pickMultipleMedia()) as XFile?;

    if (pickedVideo != null) {
      setState(() {
        _video = pickedVideo;
        _videoController = VideoPlayerController.file(File(_video!.path))
          ..addListener(() {
            if (!mounted) return;
            setState(() {});
          });
        _initializeVideoPlayerFuture = _videoController.initialize();
        _videoController.setLooping(true); // Optional: Enable looping
      });
    }
  }

  Future<void> _uploadImagesAndVideo() async {
    // Upload images
    for (File image in _images) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('multi_image_video/$imageName.jpg');
      UploadTask uploadTask = ref.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Save the downloadURL to Firebase Firestore or perform any other necessary action
      await _items.add({'imageURL': downloadURL});
    }

    // Upload video
    if (_video != null) {
      String videoName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference videoRef =
      _storage.ref().child('multi_image_video/$videoName.mp4');
      UploadTask videoUploadTask = videoRef.putFile(File(_video!.path));

      TaskSnapshot videoTaskSnapshot =
      await videoUploadTask.whenComplete(() => null);

      String videoDownloadURL = await videoTaskSnapshot.ref.getDownloadURL();

      // Save the videoDownloadURL to Firebase Firestore or perform any other necessary action
      await _items.add({'videoURL': videoDownloadURL});
    }

    // Show a toast message
    Fluttertoast.showToast(
        msg: "Data successfully registered in Firebase",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 7);

    // Navigate to the dashboard screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavigation()));

    // Clear the images and video variables after uploading
    setState(() {
      _images.clear();
      _video = null;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
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
          Center(
            child: InkWell(
              onTap: () {
                getVideoGallery();
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
                child: _video != null
                    ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                )
                    : const Center(child: Icon(Icons.video_library)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    if (isPlaying) {
                      _videoController.pause();
                    } else {
                      _videoController.play();
                    }
                    isPlaying = !isPlaying;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  setState(() {
                    _videoController.pause();
                    _videoController.seekTo(Duration.zero);
                    isPlaying = false;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  setState(() {
                    isMuted = !isMuted;
                    _videoController.setVolume(isMuted ? 0.0 : 1.0);
                  });
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: (_images.isNotEmpty || _video != null)
                  ? _uploadImagesAndVideo
                  : null,
              child: Text("Upload"),
            ),
          )
        ],
      ),
    );
  }
}

