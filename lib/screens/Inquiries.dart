import 'package:flutter/material.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';
import 'package:rescuepaws/services/auth.dart';


class Inquiries extends StatefulWidget {
  const Inquiries({Key? key}) : super(key: key); //Creating a stateful widget so
  // inquiries can update while page is loaded

  @override
  _InquiriesState createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {

  late Future myFuture;
  AuthService _auth = AuthService();
  late String id = _auth.getUID();
  List<String> docID = [];
  late FirestoreDatabase db = FirestoreDatabase(uid:'$id');
  List<Widget> list = [];
  //docID = await db.getPetCollection();



  @override
  Widget build(BuildContext context) {
    //db.getMatchCollection();
    //print('');
    return Scaffold(
      appBar: AppBar(
        title: Text('Inquiries'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      endDrawer: SidebarWidget(),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
              InquiryButton(),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            list.insert(list.length,InquiryButton());
            //getID();
          }
          );
        },
        child: Text('Click'),
      ),*/
    );
  }
}

class InquiryButton extends StatelessWidget {
  InquiryButton({
    Key? key,
  }) : super(key: key);

  List<String> names = ["Jessica", "Benjamin", "Goofy", "Ronald", "Avery", "Sean", "Erik", "Hosea", 'Brianna', 'Alyissa', 'Jack', 'Steve','Linda'];
  String name = "";

  @override
  Widget build(BuildContext context) {
    names = names..shuffle();
    name = names.first;
    return Container(
      height: 90.0,
      child: RaisedButton.icon(
        onPressed: (){
          //this.color = Colors.grey;
        },
        icon: Icon(
          Icons.circle,
          color: Color(0xFF6DAEDB), //s.blue,
        ),
        label: Text('$name Person Likes Your Pet'),
      ),
    );
  }
}
