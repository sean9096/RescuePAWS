import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/android_welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  //needed before initialize firebase to initialize binding
  await Firebase.initializeApp();             //initializes firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: AndroidWelcomePage(),
      );
    //else statement is needed just in case device is not android
    //add else if statement for ios
  }
}




