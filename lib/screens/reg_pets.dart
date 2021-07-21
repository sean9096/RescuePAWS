
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rescuepaws/services/DatabaseService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescuepaws/screens/logout.dart';


class RegisterPet extends StatefulWidget {
  const RegisterPet({Key? key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}



class _RegisterPetState extends State<RegisterPet> {

  final _formkey = GlobalKey<FormState>();

  String petName = '';
  String species = '';
  int age = 0;
  String gender = 'female';
  bool isNeutered = false;
  List<String> animalTypes = ['dog', 'cat', 'reptiles', 'other'];
  String type = 'dog';
  String contactName = '';
  String contactPhone = '';
  String contactEmail = '';
  String contactOther = '';

  List<File> _filePaths = [];
  List<String> _fileNames = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  Storage _storage = Storage();

  Future uploadImage() async {
    final uid = _auth.currentUser!.uid;
    FirestoreDatabase _firestore = FirestoreDatabase(uid: uid);
    String petID = _firestore.createPet();

    _filePaths.forEach((file) {
      final UploadTask task = _storage.uploadFileToStorage(file);
      task.snapshotEvents.listen((event) {
        if(event.state == TaskState.success) {
          event.ref.getDownloadURL().then((imageUrl) => _firestore.writeFileToFirestore(imageUrl, petID));
        }
      });
    });


  }

  Future selectImage() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);

      if(result != null) {
        _filePaths.clear();
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path!);
          _filePaths.add(file);
        });

        setState(() {
          _fileNames.clear();
          result.files.forEach((i) {
            _fileNames.add(i.name);
          });
        });
      }

    } on PlatformException catch(e) {
      print("Select Image Unsupported operation" + e.toString());
    }catch(error) {
      print("select image error");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Register',
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

                      _buildName(),     //builds name TextFormField

                      SizedBox(height: 40),

                      _buildAnimalType(),    //builds email TextFormField

                      SizedBox(height: 20),

                      _buildSpecies(),   //builds password TextFormField

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

                      Divider(thickness: 3.0, color: Colors.white,),

                      _buildContactName(),

                      SizedBox(height: 20),

                      _buildContactPhone(),

                      SizedBox(height: 20),

                      _buildConthactOther(),


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


  Future<void> setPetName(val) async {
    setState(() {
      petName = val;
    });
  }

  Widget _buildName() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Pet Name:',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if(val!.isEmpty) {
            return 'Name required';
          }else
            return null;
        },
        onChanged: (val) {
          setState(() => petName = val);
        }
    );
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
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2.0),), //borderRadius: BorderRadius.all(Radius.circular(30))),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),

      ),

      value: type,
      items: animalTypes.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text('$val'),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
         type = val as String;
          print('Animal type = $type');
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
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        obscureText: true,
        validator: (val) {

          if(val!.isEmpty) {
            return 'please specify species/breed';
          }else
            return null;
        },
        onChanged: (val) {
          setState(() => species = val);
        }

    );
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
              groupValue: gender,
              onChanged: (val) {
                gender = val as String;
                print('Gender: $gender');
                setState(() {});
              }

          ),
        ),
        
        
        Expanded(
          child: RadioListTile(
              activeColor: Colors.black,
              title: Text('Female'),
              value: 'female',
              groupValue: gender,
              onChanged: (val) {
                gender = val as String;
                print('Gender: $gender');
                setState(() {});
              }
          ),
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
              groupValue: isNeutered,
              onChanged: (val) {
                isNeutered = val as bool;
                print('isNeutered: $isNeutered');
                setState(() {});
              }

          ),
        ),


        Expanded(
          child: RadioListTile(
              activeColor: Colors.black,
              title: Text('No'),
              value: false,
              groupValue: isNeutered,
              onChanged: (val) {
                isNeutered = val as bool;
                print('isNeutered: $isNeutered');
                setState(() {});
              }
          ),
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
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 4.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        validator: (val) {
          if(val!.isEmpty) {
            return 'Name required';
          }else
            return null;
        },
        onChanged: (val) {
          setState(() => contactName = val);
        }
    );

  }

  Widget _buildContactPhone()
  {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Phone Number(optional):',
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 4.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3.0),),
        ),
        cursorColor: Colors.black,
        onChanged: (val) {
          setState(() => contactPhone = val);
        }
    );
  }

  Widget _buildConthactOther() {

    return TextField(
      decoration: InputDecoration(
        labelText: 'Other Contact Info:',
        border: OutlineInputBorder(),
      ),
      maxLines: 10,
      onChanged: (val) {
        setState(() {
          contactOther = val;
          print(contactOther);
        });
      },
    );

  }



  /*Widget _buildRegisterButton() {
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