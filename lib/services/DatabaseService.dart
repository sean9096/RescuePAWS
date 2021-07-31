import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:rescuepaws/models/user.dart';

class FirestoreDatabase {
  final String uid;


  FirestoreDatabase({required this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference pets = FirebaseFirestore.instance.collection('pets');

  Future<void> addUser(String name) async {
    Storage _storage = Storage();

    String url = await _storage.getDefaultProfilePic();

    return users.doc(uid).set({
      'Name': name,
      'pet': '',
      'likedPets': [],
      'profilePic': url,
    })
       .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }



  String createPet(Pet pet) {
    DocumentReference docRef = pets.doc();
    String petID = docRef.id;
    docRef.set({
      'owner': uid,
      'petName': pet.petName,
      'animalType': pet.type,
      'species': pet.species,
      'gender': pet.gender,
      'isNeutered': pet.isNeutered,
      'contactName': pet.contactName,
      'contactPhone': pet.contactPhone,
      'contactOther': pet.contactOther,
      'images': [],
    });
    return petID;
  }

  savePet(String petID) {
    users.doc(uid).update({'pet': petID});
  }

  writeFileToFirestore(imageUrl, String petID) {
    pets.doc(petID).update({'images': FieldValue.arrayUnion([imageUrl])});
  }

  Future<SavedUser> getUserFromFirestore(String uid)  async {
    SavedUser _user = SavedUser();

    DocumentSnapshot snapshot = await users.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    _user.SetUser(data);

    return _user;
  }

}


class Storage {
  FirebaseStorage _storage = FirebaseStorage.instance;

  uploadFileToStorage(file) {
    UploadTask task = _storage.ref().child("images/${DateTime.now().toString()}").putFile(file);
    return task;
  }

  Future<String> getDefaultProfilePic() async {
    String downloadUrl = await _storage.ref('default/dog-48490_1280.png').getDownloadURL();
    return downloadUrl;
  }



}