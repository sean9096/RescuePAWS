
class Pet {

  String petName = '';
  String species = '';
  String gender = 'female';
  bool isNeutered = false;
  String type = 'dog';
  String contactName = '';
  String contactPhone = '';
  String contactOther = '';
  List<dynamic> images = [];
  String owner = '';

  SetPet(Map<String, dynamic> data) {
    petName = data['petName'];
    species = data['species'];
    gender = data['gender'];
    isNeutered = data['isNeutered'];
    type = data['animalType'];
    contactName = data['contactName'];
    contactPhone = data['contactPhone'];
    contactOther =data['contactOther'];
    images = data['images'];
    owner = data['owner'];
  }

}