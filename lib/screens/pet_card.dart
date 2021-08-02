//swipping throguh pets
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  late Future myFuture;

  AuthService _auth = AuthService();
  late FirestoreDatabase _firestore;
  List<String> docID = [];
  late String randomPet;
  Pet _pet = Pet();
  bool isFirst = true;
  bool isLiked = false;
  late String currentPet;
  late String currentUID;
  late int cardNum;
  bool isNotEmpty = true;

  Future<void> loadData() async {
    _firestore = FirestoreDatabase(uid: _auth.getUID());
    print("FireStore instance Initialized!");

    currentUID = _auth.getUID();

    docID = await _firestore.getPetCollection();

    randomPet = docID[Random().nextInt(docID.length)];
    currentPet = randomPet;
    print("Random Pet: $randomPet");
    print("Current Pet: $currentPet");

    _pet = await _firestore.getPet(currentPet);
    docID.remove(currentPet);
    print("PetName: ${_pet.petName}");
    print("Pet Images: ${_pet.images}");
    isFirst = false;
  }

  Future<void> getNextPet() async {

    print("DOC LIST: $docID");
    if(docID.isEmpty) {
      isNotEmpty = false;
    } else {
      randomPet = docID[Random().nextInt(docID.length)];
      while (randomPet == currentPet) {
        randomPet = docID[Random().nextInt(docID.length)];
      }

      currentPet = randomPet;
      _pet = await _firestore.getPet(currentPet);
      docID.remove(currentPet);
    }





    print("PetName: ${_pet.petName}");
    print("Pet Images: ${_pet.images}");
  }

  @override
  void initState() {
    super.initState();
    myFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    // initializeFirestore();
    return Scaffold(
      endDrawer: SidebarWidget(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Color(0xFF32936F), //s.green,
        //backgroundColor: Colors.tealAccent[700],
      ),
      body: isFirst
          ? FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(child: CircularProgressIndicator()));
                }
                return _buildBody();
              })
          : isNotEmpty ? _buildBody() : Center(child: Container(child: Text("No More Matches"))),


      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        height: size.height,
        child: TinderSwapCard(
          totalNum: _pet.images.length,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          minWidth: MediaQuery.of(context).size.width * 0.85,
          minHeight: MediaQuery.of(context).size.height * 0.65,
          cardBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    /*decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(_pet.images[index]),
                          fit: BoxFit.cover),
                    ),*/
                  ),
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0),
                        ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter)),

                    //displays pet image
                    child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          //if like button is tapped then show Contact info card
                          //else display pictures
                          children: isLiked
                              ? [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contact Info:',
                                        style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      _buildContactInfo("Owner/Business Name",
                                          _pet.contactName),
                                      SizedBox(height: 15),
                                      _buildContactInfo(
                                          "Phone Number", _pet.contactPhone),
                                      SizedBox(height: 15),
                                      _buildContactInfo("Other Contact Info",
                                          _pet.contactOther),
                                    ],
                                  ),
                                ]
                              : [
                                  //displays single image from _pet.images array
                                  Ink.image(
                                      image: NetworkImage(_pet.images[index]),
                                      fit: BoxFit.fill),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Name: ${_pet.petName} (${_pet.gender})", style: TextStyle(color: Colors.white),),
                                      _buildPetInfo("Type of Animal", _pet.type),
                                      _buildPetInfo("Age", _pet.age),
                                      _buildPetInfo("Species/Breed", _pet.species),

                                      _pet.isNeutered ? _buildPetInfo("IsNeutered/Spayed", "Yes")
                                          : _buildPetInfo("IsNeutered/Spayed", "No"),

                                    ],
                                  ),
                                ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfo(String label, String data) {
    return Text("$label: $data", style: TextStyle(color: Colors.white));
  }

  Widget _buildContactInfo(String label, String contactData) {
    return Text(
      '$label:\n $contactData',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          IconButton(
            onPressed: () async {
              await getNextPet();
              setState(() {
                isLiked = false;
              });
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 40,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isLiked = false;
              });
            },
            icon: Icon(
              Icons.clear,
            ),
            iconSize: 40,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isLiked = true;
                _firestore.createMatch(currentUID, currentPet);
              });
            },
            icon: Icon(
              Icons.check,
            ),
            iconSize: 40,
          )
        ],
      ),
      color: Color(0xFF32936F), //s.green,
    );
  }
}
