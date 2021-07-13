import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescuepaws/screens/welcome.dart';
import  'package:flutter/material.dart';
import 'package:rescuepaws/screens/choice.dart';

class  AuthWrapper extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if(auth.currentUser == null) {
      return WelcomePage();
    } else {
      return ChoicePage();
    }
  }
}
