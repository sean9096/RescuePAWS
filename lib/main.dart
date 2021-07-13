
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/auth_wrapper.dart';


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
        home: AuthWrapper(),
      );
  }
}




