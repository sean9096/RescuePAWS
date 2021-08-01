import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:rescuepaws/models/user.dart';

class FirestoreDatabase {
  final String uid;


  FirestoreDatabase({required this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference pets = FirebaseFirestore.instance.collection('pets');
  CollectionReference inquiry = FirebaseFirestore.instance.collection('inquiries');

  Future <void> createMatch(String userID, String petID) {

    return inquiry.add({
      'interestedUser': userID,
      'petLiked': petID
    });
  }

  //creates user document
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



  //creates pet document and stores in firestore database
  String createPet(Pet pet) {
    DocumentReference docRef = pets.doc();
    String petID = docRef.id;
    docRef.set({
      'owner': uid,
      'petName': pet.petName,
      'age': pet.age,
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

  //saves pet id in user document
  savePet(String petID) {
    users.doc(uid).update({'pet': petID});
  }

  //uploads pet images to firestore
  writeFileToFirestore(imageUrl, String petID) {
    pets.doc(petID).update({'images': FieldValue.arrayUnion([imageUrl])});
  }

  //reads user from database, populates the user object, and returns user object
  Future<SavedUser> getUserFromFirestore(String uid)  async {
    SavedUser _user = SavedUser();

    DocumentSnapshot snapshot = await users.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    _user.SetUser(data);

    return _user;
  }

  Future<List<String>> getPetCollection()  async {
    List<String> documents = [];
    QuerySnapshot snapshot = await pets.get();

    for(int i = 0; i < snapshot.docs.length; i++) {
      documents.add(snapshot.docs[i].id);
    }

    return documents;
  }

  Future<Pet> getPet(String petID) async {
    Pet _pet = Pet();

    DocumentSnapshot snapshot = await pets.doc(petID).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _pet.SetPet(data);

    return _pet;

  }

  Future updatePet(String petID, Pet _pet) async {

    pets.doc(petID).update({
        'petName': _pet.petName,
        'age': _pet.age,
        'species': _pet.species,
        'gender': _pet.gender,
        'isNeutered': _pet.isNeutered,
        'contactName': _pet.contactName,
        'contactPhone': _pet.contactPhone,
        'contactOther': _pet.contactOther,
        'images': _pet.images,
        }
      );


  }


}


class Storage {
  FirebaseStorage _storage = FirebaseStorage.instance;

  //uploads images to storage
  uploadFileToStorage(file) {
    UploadTask task = _storage.ref().child("images/${DateTime.now().toString()}").putFile(file);
    return task;
  }

  //gets default profile picture from storage
  Future<String> getDefaultProfilePic() async {
    String downloadUrl = await _storage.ref('default/dog-48490_1280.png').getDownloadURL();
    return downloadUrl;
  }



}