
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

  //Change Password
  Future changePassword(String password) async {
      User? _user = _auth.currentUser;

      _user!.updatePassword(password).then((_) {
        print("Password Successfully changed!");
      }).catchError((error){
        print("Password Change Unsuccessful");
      });
  }

  String getUID()  {
    return _auth.currentUser!.uid;
  }

  Future<String?> getEmail() async{
    User? _user = _auth.currentUser;
    String? email = _user!.email;
    return email;
  }


  Future changeEmail(String email) async {
      User? _user = _auth.currentUser;
      bool invalid = true;

      _user!.updateEmail(email).then((_) {
        print("Email Successfully changed!");
        invalid = false;
      }).catchError((error) {
        print("Email change Unsuccessful");
        invalid = true;
      });

      if(invalid) {
        print("INVALID");
        return true;
      }
      else {
        print("VALID Email");
        return false;
      }

  }

}