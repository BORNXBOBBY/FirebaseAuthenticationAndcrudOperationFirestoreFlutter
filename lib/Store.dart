import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'CRUDE/crude_operation.dart';
import 'CRUDE/updata_firestore_data.dart';
import 'Multiimage_Video.dart';
import 'VideoAndImageUpload.dart';

class CRUDEoperation extends StatefulWidget {
  const CRUDEoperation({Key? key}) : super(key: key);

  @override
  State<CRUDEoperation> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CRUDEoperation> {
  // Existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Store'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Lottie.network(
                  'https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json'),
            ),
            const Text(
              'My MultiMedia Storage',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePickerUpload()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              child: Text('Navigate to ImagePickerUpload'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateFirestoreData()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              child: Text('Navigate to UpdateFirestoreData'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MultiImageVideo()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              child: Text('MultipleImage'),
            ),
          ],
        ),
      ),
    );
  }
}
