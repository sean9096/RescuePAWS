import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/choice.dart';
import 'package:rescuepaws/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super (key: key);

  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          color: Color(0xFF32936F),
          child: Column(
            children: [
              Image.asset('assets/rescuepaws_title.png'),

              Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        _buildEmail(),    //builds email TextForm widget

                        SizedBox(height: 40),

                        _buildPassword(), //builds password TextForm widget
                      ],
                    ),
                  ),
                ),

              Expanded(child: SizedBox(height: 0)),

              _buildSignInButton(),   //builds Sign In Button

              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              ],
            ),
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
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if(val!.isEmpty) {
            return 'Enter an email';
          }else
            return null;
        },

        onChanged: (val) {
          setState(() => email = val);
        }
    );
  }

  Widget _buildPassword() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Password:',
          labelStyle: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        obscureText: true,
        validator: (val) {
          if(val!.length < 8) {
            return 'Enter password that is at least 8 characters';
          }else
            return null;
        },

        onChanged: (val) {
          setState(() => password = val);
        }
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        if(_formKey.currentState!.validate()){
          dynamic result = await _auth.signIn(email, password);
          if(result == null) {
            setState(() {
              error = 'Could Not Sign In';
            });
          } else {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChoicePage()),
              );
            });
          }
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
        'Sign In',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }


}
