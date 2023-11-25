import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'controller/image_picker_controller.dart';

class NotificationBottomNav extends StatefulWidget {
  const NotificationBottomNav({Key? key}) : super(key: key);

  @override
  State<NotificationBottomNav> createState() => _NotificationBottomNavState();
}

class _NotificationBottomNavState extends State<NotificationBottomNav> {
  final ImagePickerController controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Gallery'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json'),
          ),
          const SizedBox(height: 20),
          const Text('Image Show', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () async {
              await controller.pickImage();
            },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, side: BorderSide.none, shape: StadiumBorder()), child: Text('Pick Your Image', style: TextStyle(color: Colors.white),)
          ),
          Obx(() {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: controller.image.value.path.isEmpty
                  ? Icon(Icons.camera, size: 50)
                  : Image.file(
                File(controller.image.value.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            );
          }),
          ElevatedButton(
            onPressed: () async {
              await controller.uploadImageToFirebase();
            },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, side: BorderSide.none, shape: StadiumBorder()), child: Text('Upload to Firebase Storage', style: TextStyle(color: Colors.white),)
          ),
          Obx(() {
            // Return the Image.network widget to display the network image
            return Image.network(controller.networkImage.value.toString());
          }),
        ],
      ),
    );
  }
}