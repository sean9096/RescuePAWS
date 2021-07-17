
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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


  List<File> _filePaths = [];
  List<String> _fileNames = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  Storage _storage = Storage();

  Future uploadImage() async {
    final uid = _auth.currentUser!.uid;
    FirestoreDatabase _firestore = FirestoreDatabase(uid: uid);

    _filePaths.forEach((file) {
      final UploadTask task = _storage.uploadFileToStorage(file);
      task.snapshotEvents.listen((event) {
        if(event.state == TaskState.success) {
          event.ref.getDownloadURL().then((imageUrl) => _firestore.writeFileToFirestore(imageUrl));
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

            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: Text('Upload Images'),
            ),

          ],
        ),
      ),
    );
  }
}