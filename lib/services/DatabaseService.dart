import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreDatabase {
  final String uid;


  FirestoreDatabase({required this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference pets = FirebaseFirestore.instance.collection('pets');

  Future<void> addUser(String name) {
    return users.doc(uid).set({
      'Name': name,
    })
       .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  writeFileToFirestore(imageUrl) {
    pets.doc().set({'owner': uid, 'images': imageUrl});
  }

}


class Storage {
  FirebaseStorage _storage = FirebaseStorage.instance;

  uploadFileToStorage(file) {
    UploadTask task = _storage.ref().child("images/${DateTime.now().toString()}").putFile(file);
    return task;
  }



}