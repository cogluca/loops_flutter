import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/infrastructure/navigation/navigation.dart';
import 'package:loops/models/AppUser.dart';
import 'package:loops/presentation/home/home.screen.dart';

import 'controllers/login.controller.dart';

//dovrebbe estendere staticamente il login Controller e non avere binding automatici a runtime, not coupled
class LoginScreen extends GetView<LoginController> {

  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(title: const Text('Loops')),
        body: Center(
            child:SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ SizedBox(
                    width: 250,
                    child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_rounded),
                      hintText: 'Email'
                    ),
                    textAlign: TextAlign.center,
                    validator: (String? value) {
                      return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                    },
                    controller: loginController.emailController,


                  ))
                ,
                  SizedBox(
                      width: 250,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.password_outlined),
                            hintText: 'Password'
                        ),
                        textAlign: TextAlign.center,
                        validator: loginController.emailValidator,
                        controller: loginController.passwordController,


                      )),
                  ElevatedButton(
                    onPressed: () => {loginController.signInWithEmail().then((value) =>
                    Get.find<GetStorage>().read('user') != null ? Get.toNamed('/home') : const SnackBar(content: Text('Sorry invalid login'), duration: Duration(seconds: 5),)),}
                      ,
                      child: const Text(
                        'Login with Email',
                        style: TextStyle(fontSize: 20),
                      )),
                  ElevatedButton(
                    child: const Text('Login with Google',
                        style: TextStyle(fontSize: 20)),
                    onPressed: ()=> {
                      loginController.signInWithGoogle().then((value) =>
                      Get.find<GetStorage>().read('user') != null ? Get.toNamed('/home') : const SnackBar(content: Text('Sorry invalid login'), duration: Duration(seconds: 5),)),}

                  ),
                ])))));
  }
}

