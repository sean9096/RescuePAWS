import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/welcome.dart';
import 'package:rescuepaws/services/auth.dart';

class  Logout extends StatefulWidget {

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  String password = '';
  String email = '';
  String emailError = '';
  String random = 'hello';
  bool validatePassword(String value) {
    String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
          children: [
            Text("Logout Page"),
            SizedBox(height: 30),
            ElevatedButton(
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
            ),
            SizedBox(height: 30),
            _buildEmail(),

            Text('$emailError',
              style: TextStyle(color: Colors.red),
            ),
            Text('$random'),

            SizedBox(height: 40),
            _buildSignInButton()

          ],
      ),
        ),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Email:',
          labelStyle: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Enter an email';
          } else
            return null;
        },
        onChanged: (val) {
          setState(() => email = val);
        });
  }


  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        dynamic invalidEmail;
        if(_formKey.currentState!.validate()) {
          print("Valid");
          invalidEmail = await _auth.changeEmail(email) ;
          if(invalidEmail) {
            setState(() {
              emailError = "invalid email";
            });
          }
        }else {
          print("NOT VALID");
        }

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
        'Change Email',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }


}