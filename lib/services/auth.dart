
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescuepaws/services/DatabaseService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register with email & password
  Future createNewUser(String email, String password, String name) async {
    try {
      UserCredential result =  await _auth.createUserWithEmailAndPassword(
          email: email, password: password,
      );
      final User? user = result.user;
      final uid = user!.uid;

      await FirestoreDatabase(uid: user.uid).addUser(name);

      return user;

    } catch(e)  {
      print(e.toString());
      return null;
    }
  }

  //sign in
  Future signIn(String email, String password) async {
    try {
      UserCredential result =  await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );
      return "Account Created";

    } catch(e)  {
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}