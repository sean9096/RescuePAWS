import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/choice.dart';
import 'package:rescuepaws/screens/editSetting.dart';
import 'package:rescuepaws/screens/setting.dart';
import 'package:rescuepaws/services/auth.dart';

class ReSignIn extends StatefulWidget {
  const ReSignIn({Key? key}) : super (key: key);

  @override
  _ReSignInState createState() => _ReSignInState();
}


class _ReSignInState extends State<ReSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF32936F),
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          color: Color(0xFF32936F),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Image.asset('assets/rescuepaws_title.png'),

                    Center(
                      child: Text(
                        'Re-Auth',
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
                    Center(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
                      child: _buildSignInButton(),
                    ),
                  ],
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEmail() {
    return Column(
      children: [
        TextFormField(
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
        ),


      ],
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
          dynamic result = await _auth.Reauthenticate(email, password);
          if(result == null) {
            setState(() {
              error = 'Invalid Credentials';
            });
          } else {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditSettingPage()),
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
        'Re-Auth',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }


}