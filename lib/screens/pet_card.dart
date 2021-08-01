import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {

  AuthService _auth = AuthService();
  late FirestoreDatabase _firestore;
  List<String> docID = [];
  late String randomID;
  Pet _pet = Pet();
  bool isFirst = true;

  void initializeFirestore() {
    _firestore = FirestoreDatabase(uid: _auth.getUID());
    print("FireStore instance Initialized!");
  }

  Future<void> getPet() async{
    docID = await _firestore.getPetCollection();
    randomID = docID[Random().nextInt(docID.length)];
    print("Random id: $randomID");
    _pet = await _firestore.getPet(randomID);
    print("PetName: ${_pet.petName}");
    print("Pet Images: ${_pet.images}");
  }


  @override
  Widget build(BuildContext context) {
    initializeFirestore();
    return Scaffold(
      endDrawer: SidebarWidget(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Colors.green,
        //backgroundColor: Colors.tealAccent[700],
      ),
      body: FutureBuilder(
          future: getPet(),
          builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: CircularProgressIndicator());
          }
          return _buildBody();
        }
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 40,
              ),

              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.clear,
                  ),
                iconSize: 40,
              ),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check,
                ),
                iconSize: 40,
              )

            ],
          ),
        color: Colors.green,
      ),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.75,
        width: size.width * 0.95,

        //displays pet image
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [
              //displays single image from _pet.images array
              Ink.image(image: NetworkImage(_pet.images[0]), fit: BoxFit.fill),
            ],
          )
        ),
      ),
    );
  }
}
