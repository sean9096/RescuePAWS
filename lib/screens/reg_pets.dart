import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescuepaws/screens/logout.dart';


class RegisterPet extends StatefulWidget {
  const RegisterPet({Key? key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {


  List<File> _paths = [];
  List<String> _fileNames = [];

  Future selectImage() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);

      if(result != null) {
        _paths.clear();
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path!);
          _paths.add(file);
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
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text('Register Pet'),

            ElevatedButton(
              onPressed: () {
                selectImage();
              },
              child: Text('Upload Images'),
            ),

            Text('$_fileNames\n'),

            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Logout()),
                  );
                },
                child: Text('Log out Page')
            ),

          ],
        ),
      ),
    );
  }
}