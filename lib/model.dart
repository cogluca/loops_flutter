//TODO Add user model used in normal sign in


class AppUser {

  String user = "";
  String credential = "";

  AppUser({required this.user, required this.credential});

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'credential': credential,
    };

  }

  AppUser.fromMap(Map map)
  : user = map['user'],
  credential = map['credential'];

}