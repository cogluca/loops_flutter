import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/navigation_infrastructure/navigation/navigation.dart';
import 'package:loops/model/AppUser.dart';
import 'package:loops/presentation/home/home.screen.dart';

import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(title: const Text('Loops')),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

              ElevatedButton(
                  child: const Text('Login with Google',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () => {
                        Get.find<LoginController>().signInWithGoogle().then(
                            (value) =>
                                Get.find<GetStorage>().read('user') != null
                                    ? Get.toNamed('/home')
                                    : const SnackBar(
                                        content: Text('Sorry invalid login'),
                                        duration: Duration(seconds: 5),
                                      )),
                      }),
            ])))));
  }
}
