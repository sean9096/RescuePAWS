import 'package:flutter/material.dart';

class AndroidSignIn extends StatefulWidget {
  const AndroidSignIn({Key? key}) : super (key: key);

  @override
  _AndroidSignInState createState() => _AndroidSignInState();
}


class _AndroidSignInState extends State<AndroidSignIn> {
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
                  child: Column(
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

                        onChanged: (val) {

                        }
                      ),

                      SizedBox(height: 40),

                      TextFormField(
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

                          onChanged: (val) {

                          }
                      ),
                    ],
                  ),
                ),

              Expanded(child: SizedBox(height: 0)),
              ElevatedButton(
                onPressed: () {},
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
                  'Log In',
                  style: TextStyle(
                    fontSize: 45.0,
                  ),
                ),
              ),

              ],
            ),
          ),
      ),
    );
  }
}
