
import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/choice.dart';
import 'package:rescuepaws/services/auth.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';
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
          child: ListView(
            children: [
              Image.asset('assets/rescuepaws_title.png'),

              Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [

                      _buildName(),     //builds name TextFormField

                      SizedBox(height: 20),

                      _buildEmail(),    //builds email TextFormField

                      SizedBox(height: 20),

                      _buildPassword(),   //builds password TextFormField

                      SizedBox(height: 20),

                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),

                      _buildRegisterButton(),

                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }



  Widget _buildName() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Name:',
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
            return 'Name required';
          }else
            return null;
        },
        onChanged: (val) {
          setState(() => name = val);
        }
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

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if(_formkey.currentState!.validate()){
          dynamic result = await _auth.createNewUser(email, password, name);

          if(result == null) {
            setState(() {
              error = 'please supply a valid email';
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
        'Register',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }


}