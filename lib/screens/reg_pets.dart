import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rescuepaws/screens/choice.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescuepaws/models/pet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class RegisterPet extends StatefulWidget {
  const RegisterPet({Key? key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  final _formkey = GlobalKey<FormState>();
  final maskFormatter = new MaskTextInputFormatter(
      mask: '###-###-####', filter: {"#": RegExp(r'[0-9]')});

  Pet _pet = Pet();
  List<String> animalTypes = ['dog', 'cat', 'reptile', 'other'];
  int minUpload = 3;
  String contactError = '';
  String selectError = '';
  String formError = '';

  List<File> _filePaths = [];
  List<String> _fileNames = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  Storage _storage = Storage();

  Future uploadImage() async {
    final uid = _auth.currentUser!.uid;
    FirestoreDatabase _firestore = FirestoreDatabase(uid: uid);
    String petID = _firestore.createPet(_pet);
    _firestore.savePet(petID);

    _filePaths.forEach((file) {
      final UploadTask task = _storage.uploadFileToStorage(file);
      task.snapshotEvents.listen((event) {
        if (event.state == TaskState.success) {
          event.ref.getDownloadURL().then(
              (imageUrl) => _firestore.writeFileToFirestore(imageUrl, petID));
        }
      });
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SidebarWidget(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Colors.transparent,
        //backgroundColor: Colors.tealAccent[700],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          color: Color(0xFF32936F),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                Image.asset('assets/rescuepaws_title.png'),
                Center(
                  child: Text(
                    'Register Pet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    children: [
                      _buildName(), //builds name TextFormField

                      SizedBox(height: 40),

                      _buildAnimalType(), //builds email TextFormField

                      SizedBox(height: 20),

                      _buildSpecies(), //builds password TextFormField

                      SizedBox(height: 40),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      _buildGender(),

                      SizedBox(height: 30),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Is Pet Neutered/Spayed:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      _buildIsNeutered(),
                      SizedBox(height: 50),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Info',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      Divider(
                        thickness: 3.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      _buildContactName(),

                      SizedBox(height: 30),

                      Text(
                        '$contactError',
                        style: TextStyle(color: Colors.red),
                      ),
                      _buildContactPhone(),

                      SizedBox(height: 50),

                      _buildContactOther(),

                      SizedBox(height: 30),

                      Row(
                        children: [
                          Text(
                            '$selectError',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),

                      _buildUploadButton(),

                      Row(
                        children: [
                          Flexible(child: Text('$_fileNames')),
                        ],
                      ),

                      SizedBox(height: 70),

                      Text(
                        '$formError',
                        style: TextStyle(color: Colors.red),
                      ),
                      _buildRegisterButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Pet Name:',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Name required';
          } else
            return null;
        },
        onChanged: (val) {
          setState(() => _pet.petName = val);
        });
  }

  Widget _buildAnimalType() {
    return DropdownButtonFormField(
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Type of Animal:',
        labelStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0),
        ), //borderRadius: BorderRadius.all(Radius.circular(30))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 3.0),
        ),
      ),
      value: _pet.type,
      items: animalTypes.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text('$val'),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _pet.type = val as String;
          print('Animal type = ${_pet.type}');
        });
      },
    );
  }

  Widget _buildSpecies() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Specific Species/Breed:',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if (val!.isEmpty) {
            return 'please specify species/breed';
          } else
            return null;
        },
        onChanged: (val) {
          setState(() => _pet.species = val);
        });
  }

  Widget _buildGender() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RadioListTile(
              activeColor: Colors.black,
              title: Text('Male'),
              value: 'male',
              groupValue: _pet.gender,
              onChanged: (val) {
                _pet.gender = val as String;
                print('Gender: ${_pet.gender}');
                setState(() {});
              }),
        ),
        Expanded(
          child: RadioListTile(
              activeColor: Colors.black,
              title: Text('Female'),
              value: 'female',
              groupValue: _pet.gender,
              onChanged: (val) {
                _pet.gender = val as String;
                print('Gender: ${_pet.gender}');
                setState(() {});
              }),
        ),
      ],
    );
  }

  Widget _buildIsNeutered() {
    return Row(
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
    );
  }

  Widget _buildContactName() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Owner or Business Name:',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Name required';
          } else
            return null;
        },
        onChanged: (val) {
          setState(() => _pet.contactName = val);
        });
  }

  Widget _buildContactPhone() {
    return TextFormField(
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Phone Number(optional):',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
        ),
        cursorColor: Colors.black,
        validator: (val) {
          if (val!.length > 0 && val.length < 12) {
            return 'invalid phone number';
          } else {
            return null;
          }
        },
        onChanged: (val) {
          setState(() => _pet.contactPhone = val);
          print("Phone Number = ${_pet.contactPhone}");
        });
  }

  Widget _buildContactOther() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Other Contact Info:',
        labelStyle: TextStyle(
          color: Colors.white,
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

  Widget _buildUploadButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            selectImage();
          },
          child: Text(
            'Upload Images',
            style: TextStyle(fontSize: 17.0),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF6DAEDB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            side: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formkey.currentState!.validate() &&
            (_pet.contactPhone.isNotEmpty || _pet.contactOther.isNotEmpty) &&
            (_filePaths.length >= minUpload)) {
          setState(() {
            uploadImage();
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => ChoicePage()),
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

            if (_filePaths.length < minUpload) {
              selectError = 'please select at least $minUpload pictures';
            }
          });
          formError = 'please fill required fields';
        }
      },
      child: Text(
        'Register',
        style: TextStyle(fontSize: 45.0),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF6DAEDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        side: BorderSide(color: Colors.black, width: 2.0),
        padding: EdgeInsets.fromLTRB(55, 5, 50, 5),
        minimumSize: Size(248.0, 0),
      ),
    );
  }

/*
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if(_formkey.currentState!.validate()){
          dynamic result = await _auth.createNewUser(email, password, name);

          if(result == null) {
            setState(() {
              error = 'please supply a valid email';
            });
          } else {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChoicePage()),
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
        'Register',
        style: TextStyle(
          fontSize: 45.0,
        ),
      ),
    );
  }
 */

}
