import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/user.dart';
import 'package:rescuepaws/screens/logout.dart';
import 'package:rescuepaws/screens/reg_pets.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class ChoicePage extends StatefulWidget {
  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  SavedUser _user = SavedUser();
  String regError = '';

  Future<bool> petValid() async {
    final uid = _auth.currentUser!.uid;
    FirestoreDatabase _firestore = FirestoreDatabase(uid: uid);
    _user = await _firestore.getUserFromFirestore(uid);

    if (_user.pet.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SidebarWidget(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Colors.transparent,
        //backgroundColor: Colors.tealAccent[700],
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        color: Color(0xFF32936F),
        child: ListView(
          children: [
            Image.asset('assets/rescuepaws_title.png'),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  _buildLook(),
                  SizedBox(
                    height: 40,
                  ),
                  _buildRegisterPet(),
                  Text(
                    '$regError',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterPet() {
    return ElevatedButton(
      onPressed: () async {
        bool valid = await petValid();
        if (valid) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPet()));
        } else {
          setState(() {
            regError =
            'Only 1 pet per user can be registered. Delete current pet to register a new one';
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF6DAEDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        side: BorderSide(color: Colors.black, width: 2.0),
        padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
        //minimumSize: Size(248.0, 0),
      ),
      child: Text(
        'Register a Pet',
        style: TextStyle(
          fontSize: 40.0,
        ),
      ),
    );
  }

  Widget _buildLook() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Logout()));
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF6DAEDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        side: BorderSide(color: Colors.black, width: 2.0),
        padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
        //minimumSize: Size(248.0, 0),
      ),
      child: Text(
        'Look for a Pet',
        style: TextStyle(
          fontSize: 40.0,
        ),
      ),
    );
  }


}