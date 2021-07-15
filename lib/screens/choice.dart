
import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/reg_pets.dart';
import 'package:rescuepaws/services/auth.dart';

class  ChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Choice Page"),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPet() ));

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
            'Register Pet',
            style: TextStyle(
              fontSize: 45.0,
            ),
          ),
        ),
      ],
    );
  }
}
