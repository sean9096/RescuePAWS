

class SavedUser {
  String Name = '';
  List<dynamic> likedPets = [];
  String pet = '';

  SetUser(Map<String, dynamic> data) {
    Name = data['Name'];
    likedPets = data['likedPets'];
    pet = data['pet'];
  }
}