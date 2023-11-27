import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'CRUDE/crude_operation.dart';
import 'CRUDE/updata_firestore_data.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePickerUpload()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Navigate to ImagePickerUpload'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateFirestoreData()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Navigate to UpdateFirestoreData'),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _create(),
      //   backgroundColor: const Color.fromARGB(255, 88, 136, 190),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
