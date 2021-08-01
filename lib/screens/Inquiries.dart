import 'package:flutter/material.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';


class Inquiries extends StatefulWidget {
  const Inquiries({Key? key}) : super(key: key); //Creating a stateful widget so
  // inquiries can update while page is loaded

  @override
  _InquiriesState createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {

  List<Widget> list = [];
  FirestoreDatabase db = FirestoreDatabase(uid: 'fm34f34');


  /*for(var i =0; i<4; i++)
  {
    list.add(InquiryButton());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inquiries'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      endDrawer: SidebarWidget(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: list /*[
          InquiryButton(),
          InquiryButton()
        ],*/
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            list.insert(list.length,InquiryButton());
            db.createMatch('mark','jade');
          }
          );
        },
        child: Text('Click'),
      ),
    );
  }
}

class InquiryButton extends StatelessWidget {
  const InquiryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      child: RaisedButton.icon(
        onPressed: (){},
        icon: Icon(
          Icons.circle,
          color: Colors.blue,
        ),
        label: Text('This Person Likes Your Pet'),
      ),
    );
  }
}
