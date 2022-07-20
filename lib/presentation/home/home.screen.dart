import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model/Project.dart';
import 'package:loops/presentation/home/ProjectTile.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(onPressed: () => {}, icon: const Icon(Icons.add_alert)),
          ],
        ),
        drawer: Drawer(
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
                  child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(controller.imageUrl.value),
                            ),
                            Text(
                              Get.find<HomeController>().username.value,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              homeController.emailOnScreen.value,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ]))),
              ListTile(
                title: const Text('Print'),
                onTap: () {
                  controller.onTap();
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  await controller.logOut();
                  Get.offNamed('/login');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<List<Project>>(
                  stream: homeController.getProjects(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Project>> response) {
                    //does a get builder have a size constraint ?
                    return GetBuilder<HomeController>(
                        init: Get.find<HomeController>(),
                        builder: (value) {
                          if (response.hasData) {
                            return ListView.builder(
                                itemCount: response.data?.length,
                                itemBuilder: (context, int index) {
                                  return ProjectTile(response.data![index]);
                                });
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed('/project_creation'),

            child: const Icon(Icons.add)));
  }
}
