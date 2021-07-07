import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/android_signin.dart';

class AndroidWelcomePage extends StatelessWidget {
  const AndroidWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6DAEDB),
      body: Column(
       // mainAxisAlignment: MainAxisAlignment.end,
        children: [
         // Divider(
           // height: 80,
          //),
          Image.asset(
              'assets/rescuepaws_title.png',
            ),
          Expanded(child: SizedBox(height: 0)),
          Center(
            heightFactor:  1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AndroidSignIn()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF32936F),
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
                  fontSize: 40.0,
                ),
              ),
            ),
          ),

          Center(
            heightFactor:  2.5,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF32936F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  side: BorderSide(color: Colors.black, width: 2.0),
                  padding: EdgeInsets.fromLTRB(55, 5, 50, 5),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}

