import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                      onPressed: (){
                        //TODO: Implement Login with mail
                      }, //this should pop out either a modal box or switch elements into th screen to two text input fields
                      child: const Text(
                        'Login with Email',
                        style: TextStyle(fontSize: 20),
                      )),
                  ElevatedButton(
                    child: const Text('Login with Google',
                        style: TextStyle(fontSize: 20)),
                    onPressed: loginController.signInWithGoogle,
                  ),
                ])))));
  }
}

