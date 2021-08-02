import 'package:flutter/material.dart';
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
  
  bool showPassword = false;
  String petName = "";
  String age = "";
  
  Future<void> loadData() async {
    _firestore = FirestoreDatabase(uid: _auth.getUID());
    print("FireStore instance Initialized!");
    
    _user = await _firestore.getUserFromFirestore(_auth.getUID());
    _pet = await _firestore.getPet(_user.pet);
    
  }

  Future<void> updatePet() async {
    _firestore.updatePet(_user.pet, _pet);
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
                        buildContactOther(),
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
                              onPressed: () {
                                //updatePet();
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

        onChanged: (val) {
          setState(() {
            _pet.age = val;
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


}
