import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:rescuepaws/models/user.dart';
import 'package:rescuepaws/screens/setting.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:rescuepaws/services/auth.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PetEditSettingPage extends StatefulWidget {
  @override
  _PetEditSettingPageState createState() => _PetEditSettingPageState();
}

class _PetEditSettingPageState extends State<PetEditSettingPage> {
  final _formkey = GlobalKey<FormState>();
  final maskFormatter = new MaskTextInputFormatter(
      mask: '###-###-####', filter: {"#": RegExp(r'[0-9]')});

  late Future myFuture;

  late FirestoreDatabase _firestore;
  AuthService _auth = AuthService();
  Pet _pet = Pet();
  SavedUser _user = SavedUser();
  Storage _storage = Storage();
  
  bool showPassword = false;
  List<File> _filePaths = [];
  List<String> _fileNames = [];
  String selectError = '';
  String contactError = '';
  String formError = '';
  int minUpload = 3;
  bool petEmpty = false;

  Future<void> loadData() async {
    _firestore = FirestoreDatabase(uid: _auth.getUID());
    print("FireStore instance Initialized!");
    
    _user = await _firestore.getUserFromFirestore(_auth.getUID());

    if(_user.pet.isEmpty) {
      petEmpty = true;
    }else {
      _pet = await _firestore.getPet(_user.pet);
    }

    
  }

  Future uploadImage() async {

    if(_filePaths.isEmpty) {
      _firestore.updatePetNoPic(_user.pet, _pet);
    } else {
      _firestore.updatePetPic(_user.pet, _pet);
      _filePaths.forEach((file) {
        final UploadTask task = _storage.uploadFileToStorage(file);
        task.snapshotEvents.listen((event) {
          if (event.state == TaskState.success) {
            event.ref.getDownloadURL().then(
                    (imageUrl) =>
                    _firestore.writeFileToFirestore(imageUrl, _user.pet));
          }
        });
      });
    }
  }


  Future selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (result != null) {
        _filePaths.clear();
        selectError = '';
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path!);
          _filePaths.add(file);
        });

        setState(() {
          _fileNames.clear();
          result.files.forEach((i) {
            _fileNames.add(i.name);
            if (_filePaths.length < minUpload) {
              selectError = 'please select at least $minUpload pictures.';
            }
          });
        });
      }
    } on PlatformException catch (e) {
      print("Select Image Unsupported operation" + e.toString());
    } catch (error) {
      print("select image error");
    }
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
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          } else if(snapshot.connectionState == ConnectionState.done && petEmpty) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  elevation: 1,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage()));
                    },
                  ),
                ),

              endDrawer: SidebarWidget(),

              body: Center(child: Container(child: Text("Pet has not been registered"),),),

            );
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
                    color: Colors.purple,
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
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      children: [
                        Text(
                          "Edit Pet Profile",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
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
                                          _pet.images[0],
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
                                      color: Colors.purple,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        buildNameTextField("Pet Name", _pet.petName, _pet.petName),
                        buildAgeTextField("Pet Age", _pet.age, _pet.age),
                        buildSpeciesTextField('Species/Breed', _pet.species, _pet.species),
                        Text('Is pet Neutered/Spayed:'),
                        buildIsNeutered(),
                        buildContactNameTextField('Owner/Business Name:', _pet.contactName, _pet.contactName),
                        buildPhoneTextField('Phone Number', _pet.contactPhone, _pet.contactPhone),

                        Text(
                          '$contactError',
                          style: TextStyle(color: Colors.red),
                        ),
                        buildContactOther(),

                        Row(
                          children: [
                            Text(
                              '$selectError',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 30, right: 50),
                          child: Row(
                            children: [
                              buildUploadButton(),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Flexible(child: Text('$_fileNames')),
                          ],
                        ),

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
                                if (_formkey.currentState!.validate() &&
                                    (_pet.contactPhone.isNotEmpty || _pet.contactOther.isNotEmpty) &&
                                    (_filePaths.length >= minUpload || _filePaths.isEmpty)) {
                                  setState(() {
                                      print("FORM SUCCESSFULL!!!");
                                      uploadImage();
                                      //updatePet();
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(builder: (context) => SettingsPage()),
                                      );
                                  });
                                } else {
                                  setState(() {
                                    if (_pet.contactPhone.isEmpty && _pet.contactOther.isEmpty) {
                                      contactError =
                                      'please provide a phone number or other form of contact';
                                    } else {
                                      contactError = '';
                                    }

                                    if (_filePaths.length < minUpload && _filePaths.isNotEmpty) {
                                      selectError = 'please select at least $minUpload pictures';
                                    }
                                  });
                                  formError = 'please fill required fields';
                                }
                              },

                              color: Colors.purple,
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
              ),
            );

        }
    );
  }

  Widget buildNameTextField(
      String labelText, String placeholder, String updateData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),

        validator: (val) {
          if (val!.isEmpty) {
            return 'Name required';
          } else
            return null;
        },

        onChanged: (val) {
          setState(() {
            _pet.petName = val;
            print("Updated Data: ${_pet.petName}");

          });
        },
      ),
    );
  }


  Widget buildAgeTextField(
      String labelText, String placeholder, String updateData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),

        validator: (val) {
          if (val!.isEmpty) {
            return 'Age required';
          } else
            return null;
        },

        onChanged: (val) {
          setState(() {
            _pet.age = val;
            print("Updated Data: ${_pet.age}");
          });
        },
      ),
    );
  }

  Widget buildSpeciesTextField(
      String labelText, String placeholder, String updateData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),

        validator: (val) {
          if (val!.isEmpty) {
            return 'Species/Breed required';
          } else
            return null;
        },

        onChanged: (val) {
          setState(() {
            _pet.species = val;
            print("Updated Data: ${_pet.species}");
          });
        },
      ),
    );
  }

  Widget buildIsNeutered() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RadioListTile(
                activeColor: Colors.black,
                title: Text('Yes'),
                value: true,
                groupValue: _pet.isNeutered,
                onChanged: (val) {
                  _pet.isNeutered = val as bool;
                  print('isNeutered: ${_pet.isNeutered}');
                  setState(() {});
                }),
          ),
          Expanded(
            child: RadioListTile(
                activeColor: Colors.black,
                title: Text('No'),
                value: false,
                groupValue: _pet.isNeutered,
                onChanged: (val) {
                  _pet.isNeutered = val as bool;
                  print('isNeutered: ${_pet.isNeutered}');
                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  Widget buildContactNameTextField(
      String labelText, String placeholder, String updateData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),

        validator: (val) {
          if (val!.isEmpty) {
            return 'Owner/Business name required';
          } else
            return null;
        },

        onChanged: (val) {
          setState(() {
            _pet.contactName = val;
            print("Updated Data: ${_pet.contactName}");
          });
        },
      ),
    );
  }

  Widget buildPhoneTextField(
      String labelText, String placeholder, String updateData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),

        validator: (val) {
          if (val!.length > 0 && val.length < 12) {
            return 'invalid phone number';
          } else {
            return null;
          }
        },

        onChanged: (val) {
          setState(() {
            _pet.contactPhone = val;
            print("Updated Data: ${_pet.contactPhone}");
          });
        },
      ),
    );
  }

  Widget buildContactOther() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Other Contact Info:',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3.0)),
      ),
      cursorColor: Colors.black,
      maxLines: 10,
      onChanged: (val) {
        setState(() {
          _pet.contactOther = val;
          print(_pet.contactOther);
        });
      },
    );
  }

  Widget buildUploadButton() {
    return RaisedButton(
      onPressed: () {
        selectImage();
      },

      color: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 25),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        "Upload Images",
        style: TextStyle(
            fontSize: 14,
            letterSpacing: 2.2,
            color: Colors.white),
      ),
    );
  }


}
