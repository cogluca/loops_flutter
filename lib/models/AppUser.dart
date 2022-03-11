//TODO Add user model used in normal sign in


class AppUser {
  String? _user = "";
  String? _email = "";
  String? _credential = "";
  String? _imageUrl = "";

  AppUser(String? user, String? email, String? credential, String? imgUrl){
    _user= user;
    _email= email;
    _credential = credential;
    _imageUrl = imgUrl;
  }

  Map<String, dynamic> toMap() {
    return {
      'user': _user,
      'email': _email,
      'credential': _credential,
      'imageUrl': _imageUrl
    };

  }

  AppUser.fromMap(Map map)
  : _user = map['user'],
  _email = map['email'],
  _credential = map['credential'],
  _imageUrl = map['imageUrl'];

  String? get user => _user;

  String? get email => _email;

  String? get credential => _credential;

  String? get imageUrl => _imageUrl;
}