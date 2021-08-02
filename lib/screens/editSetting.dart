//edit profile
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rescuepaws/models/user.dart';
import 'package:rescuepaws/screens/setting.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class EditSettingPage extends StatefulWidget {
  @override
  _EditSettingPageState createState() => _EditSettingPageState();
}

class _EditSettingPageState extends State<EditSettingPage> {
  late Future myFuture;
  bool showPassword = false;
  late String email;
  late File _filePath;
  String avatar = '';
  String invalidEmail = '';
  String updatedEmail = '';

  late FirestoreDatabase _firestore;
  AuthService _auth = AuthService();
  SavedUser _user = SavedUser();
  Storage _storage = Storage();

  Future<void> loadData() async {
    _firestore = FirestoreDatabase(uid: _auth.getUID());
    print("FireStore instance Initialized!");

    _user = await _firestore.getUserFromFirestore(_auth.getUID());
    avatar = _user.profilePic;
    email = (await _auth.getEmail())!;
  }


  Future selectImage() async {

      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image);

        if(result != null) {
          _filePath = File(result.files.single.path!);
          //_storage.uploadFileToStorage(_filePath);

          final UploadTask task = _storage.uploadFileToStorage(_filePath);
          task.snapshotEvents.listen((event) {
            if (event.state == TaskState.success) {
              event.ref.getDownloadURL().then(
                      (imageUrl) {
                        setState(() {
                          avatar = imageUrl;
                        });
                      });
            }
         });
    }
  }

  Future saveChanges() async {
    _user.profilePic = avatar;
    print("Profile Pic: ${_user.profilePic}");
    _firestore.updateUser(_user);
  }


  @override
  void initState() {
    super.initState();
    myFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF6DAEDB), //s.purple,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage()));
              },
            ),
            /*actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage()));
              },
            ),
          ],*/
          ),
          endDrawer: SidebarWidget(),
          body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    avatar,
                                  ))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                ),
                                color: Color(0xFF6DAEDB), //s.purple,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  buildNameTextField("Full Name", _user.Name, false),
                  buildEmailTextField("E-mail", email, false),
                  Text("$invalidEmail", style: TextStyle(color: Colors.red)),
                  //buildTextField("Password", "********", true),
                  //buildTextField("Location", "TLV, Israel", false),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {},
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print("NAME: ${_user.Name}");
                          print("Email: $email");

                          if(email != updatedEmail) {
                            dynamic validEmail = await _auth.changeEmail(email);

                            if(validEmail == null) {
                              setState(() {
                                invalidEmail = "invalid email";
                              });
                            }else {
                              saveChanges();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      SettingsPage()),
                                      (route) => false);
                            }
                          }else {
                            saveChanges();
                          }



                        },
                        color: Color(0xFF6DAEDB),
                        //s.purple,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildNameTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
        onChanged: (val) {
          setState(() {
            _user.Name = val;
          });

        },
      ),
    );
  }


  Widget buildEmailTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),

          onChanged: (val) {
            setState(() {
              updatedEmail = val;
            });

          },
      ),
    );
  }



}
