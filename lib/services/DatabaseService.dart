import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  final String uid;


  FirestoreDatabase({required this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<void> addUser(String name) {
    return users.doc(uid).set({
      'Name': name,
    })
       .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

}