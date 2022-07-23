//TODO Add user model used in normal sign in


class AppUser {
  String _userUid;
  String _user;
  String _email;
  String _credential;
  String _imageUrl;

  AppUser(this._userUid, this._user, this._email, this._credential,
      this._imageUrl);

  Map<String, dynamic> toMap() {
    return {
      'userUid': _userUid,
      'user': _user,
      'email': _email,
      'credential': _credential,
      'imageUrl': _imageUrl
    };
  }

  factory AppUser.fromMap(Map map){
    return AppUser(map['userUid'], map['user'], map['email'], map['credential'],
        map['imageUrl']);
  }

    String get user =>
    _user;

    String get email =>
    _email;

    String get credential =>
    _credential;

    String get imageUrl =>
    _imageUrl;

    String get userUid =>
    _userUid;

    set userUid(String value) {
      _userUid = value;
    }
  }