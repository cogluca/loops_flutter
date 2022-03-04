import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model.dart';

import 'package:loops/repository/login_repository.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  LoginRepository loginRepository = LoginRepository();
  GetStorage storage = GetStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;


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

  Future<AppUser> signInWithEmail() async{
    UserCredential userCredential = await loginRepository.verifyUser(email: emailController.text, password: passwordController.text);
    AppUser loggedInUser = AppUser(user: userCredential.user.toString(), credential: userCredential.credential.toString());
    storage.write("user", loggedInUser.toMap());
    return loggedInUser;
  }

  Future<AppUser> signInWithGoogle() async {

    UserCredential userCredential = await loginRepository.signInWithGoogle();
    AppUser loggedInUser = AppUser(user: userCredential.user.toString(), credential: userCredential.credential.toString());
    storage.write("user", loggedInUser.toMap());
    return loggedInUser;
  }


}
