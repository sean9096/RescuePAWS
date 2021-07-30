
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/user.dart';
import 'package:rescuepaws/screens/reg_pets.dart';
import 'package:rescuepaws/screens/setting.dart';
import 'package:rescuepaws/screens/welcome.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';

class  ChoicePage extends StatefulWidget {
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
    _user = await _firestore.getUser(uid);

    if(_user.pet.isEmpty) {
      return true;
    }else {
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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

                  SizedBox(height: 40,),

                  _buildRegisterPet(),

                  Text(
                    '$regError',
                    style: TextStyle(color: Colors.red),
                  ),

                ],
              ),
            ),
            

          


            SizedBox(height: 30),
            _buildLogOut(),


          ],
        ),
      ),
    );
  }


  Widget _buildRegisterPet() {
     return ElevatedButton(
       onPressed: ()  async {
         bool valid = await petValid();
         if(valid) {
           Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => RegisterPet() ));
         }else {
           setState(() {
             regError = 'only 1 pet per user can be registered. Delete current pet to register a new one';
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
           fontSize: 45.0,
         ),
       ),
     );
  }

  Widget _buildLook() {
    return ElevatedButton(
      onPressed: ()  {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage() ));
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
        'Looking for a Pet',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }

  Widget _buildLogOut() {
     return  ElevatedButton(
       onPressed: () {
         AuthService().signOut();
         Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(builder: (context) => WelcomePage() ),
                 (route) => false);

       },
       style: ElevatedButton.styleFrom(
         primary: Color(0xFF6DAEDB),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50.0),
         ),
         side: BorderSide(color: Colors.black, width: 2.0),
         padding: EdgeInsets.fromLTRB(55, 5, 50, 5),
         minimumSize: Size(248.0, 0),
       ),
       child: Text(
         'Log Out',
         style: TextStyle(
           fontSize: 45.0,
         ),
       ),
     );
  }


}
