import 'package:flutter/material.dart';
import 'package:rescuepaws/main.dart';

class AndroidWelcomePage extends StatelessWidget {
  const AndroidWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6DAEDB),
      body: Column(
       // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Divider(
            height: 80,
          ),
          Image.asset(
              'assets/temp_logo.jpg',
              scale: 10,
            ),
          Expanded(
            child: Divider(
              height: 0,
            ),
          ),
          Center(
            heightFactor:  1.5,
            child: ElevatedButton(
              onPressed: () {},
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
                'Log In',
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ),
          ),

          Center(
            heightFactor:  2.0,
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

