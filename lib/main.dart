import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BottomNavigation.dart';
import '../SplashScreen.dart';
import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: 'gs://authflutter-c5045.appspot.com',
          apiKey: 'AIzaSyB-p8XLZiRPJwEdnqtPmuqIkcpmtyJuc0U',
          appId: '1:932623245436:android:6aa87e6b0e219a3eed69f9',
          messagingSenderId: '932623245436',
          projectId: 'authflutter-c5045'

      )

  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return const BottomNavigation();
        }
        else {
          return const SplashScreen();

        }
      },
    );
  }
}


// import 'package:flutter/cupertino.dart';
//
// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }