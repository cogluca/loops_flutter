import 'package:get/get.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';
import 'package:flutter/material.dart';


class LeftDragDrawer extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Obx(() =>
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              Get
                                  .find<HomeController>()
                                  .imageUrl
                                  .value),
                        ),
                        Text(
                          Get
                              .find<HomeController>()
                              .username
                              .value,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          Get
                              .find<HomeController>()
                              .emailOnScreen
                              .value,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ]))),
          ListTile(
            title: const Text('Print'),
            onTap: () {
              Get.find<HomeController>().onTap();
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Go to Projects'),
            onTap: () {
              Get.offAllNamed('/home');
              // Update the state of the app
              // ...
              // Then close the drawer
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              // Update the state of the app
              // ...
              // Then close the drawer
              await Get.find<HomeController>().logOut();

              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}