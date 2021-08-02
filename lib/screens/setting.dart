//settings screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/user.dart';
import 'package:rescuepaws/screens/editSetting.dart';
import 'package:rescuepaws/screens/petEditSetting.dart';
import 'package:rescuepaws/screens/welcome.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class SettingsPage extends StatefulWidget {
  static final String path = "lib/src/pages/settings/setting.dart";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future myFuture;
  late bool _dark;
  SavedUser _user = SavedUser();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late FirestoreDatabase _firestore;


  Future<void> loadData() async {
    _firestore = FirestoreDatabase(uid: _auth.currentUser!.uid);
    print("FireStore instance Initialized!");

    _user = await _firestore.getUserFromFirestore(_auth.currentUser!.uid);
    print("User: ${_user.Name}");
  }

  @override
  void initState() {
    super.initState();
    _dark = false;
    myFuture = loadData();
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
            return Scaffold(
            backgroundColor: _dark ? null : Colors.grey.shade200,
            appBar: AppBar(
              elevation: 0,
              brightness: _getBrightness(),
              iconTheme: IconThemeData(
                  color: _dark ? Colors.white : Colors.black),
              backgroundColor: Colors.transparent,
              title: Text(
                'Settings',
                style: TextStyle(color: _dark ? Colors.white : Colors.black),
              ),
              /*actions: <Widget>[
              IconButton(
                icon: Icon(Icons.brightness_2_rounded),
                onPressed: () {
                  setState(() {
                    _dark = !_dark;
                  });
                },
              )
            ],*/
            ),
            endDrawer: SidebarWidget(),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Color(0xFF32936F), //s.purple,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditSettingPage()));
                          },
                          title: Text(
                            "${_user.Name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(_user.profilePic),
                            backgroundColor: Colors.transparent,
                          ),
                          trailing: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.fromLTRB(
                            32.0, 8.0, 32.0, 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.edit,
                                color: Color(0xFF6DAEDB), //s.purple,
                              ),
                              title: Text("Change Pet Information"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PetEditSettingPage()));
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                Icons.report_problem,
                                color: Color(0xFF6DAEDB), //s.purple,
                              ),
                              title: Text("Report Problem"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                //open Report Problem
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Notification Settings",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF32936F), //s.indigo,
                        ),
                      ),
                      SwitchListTile(
                        activeColor: Color(0xFF6DAEDB),
                        //s.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received notification"),
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 60.0),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF6DAEDB), //s.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 00,
                  left: 00,
                  child: IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AuthService().signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              WelcomePage()),
                              (route) => false);
                    },
                  ),
                )
              ],
            ),
          );

        }
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
