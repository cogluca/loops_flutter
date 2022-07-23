import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model/AppUser.dart';

import 'package:loops/repository/login_repository.dart';

class LoginController extends GetxController {

  LoginRepository loginRepository = LoginRepository();
  GetStorage storage = GetStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  late AppUser _loggedInUser;


  AppUser get loggedInUser => _loggedInUser;

  set loggedInUser(AppUser value) {
    _loggedInUser = value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? emailValidator(String? email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
    return emailValid ? null: "something went wrong";

  }

  ///Signs in by first generating user credentials and then with such credentials writes the logged in user to storage
  Future<AppUser> signInWithEmail() async{
    UserCredential userCredential = await loginRepository.verifyUser(email: emailController.text, password: passwordController.text);

    String? usernm = userCredential.user?.displayName;
    String? email = userCredential.user?.email;
    String? imgNetworkUrl = userCredential.user?.photoURL;
    String? userUid = userCredential.user?.uid;

    AppUser loggedInUser = AppUser(userUid.toString(), usernm.toString() ,email.toString(), userCredential.credential.toString(), imgNetworkUrl.toString());
    storage.write("user", loggedInUser.toMap());
    return loggedInUser;
  }



  ///Signs in by first generating user credentials and then with such credentials writes the logged in user to storage
  Future<AppUser> signInWithGoogle() async {

    UserCredential userCredential = await loginRepository.signInWithGoogle();

    String? usernm = userCredential.user?.displayName.toString();
    String? email = userCredential.user?.email;
    String? imgNetworkUrl = userCredential.user?.photoURL;

    String? id = userCredential.user?.uid;

    loggedInUser = AppUser(id.toString(), usernm.toString() ,email.toString(), userCredential.credential.toString(), imgNetworkUrl.toString());

    storage.write("user", loggedInUser.toMap());
    return loggedInUser;



  }




}
