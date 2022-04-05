import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/models/Project.dart';
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
          StreamBuilder<List<Project>>(
              stream: homeController.getProjects(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Project>> response) {
                return Expanded(
                    child: GetBuilder<HomeController>(
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
                        }));
              })
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => {
                  showDialog(
                    builder: (BuildContext context) {
                      return Dialog(
                          child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Project name',
                                hintText: 'Enter project name',
                                border: OutlineInputBorder(),
                              ),
                              controller: homeController.createdNewProject,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Project shortDescription',
                                hintText: 'Enter project name',
                                border: OutlineInputBorder(),
                              ),
                              controller: homeController.oneLiner,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Project goal',
                                hintText: 'Enter project name',
                                border: OutlineInputBorder(),
                              ),
                              controller: homeController.projectGoal,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'When will the project start ?',
                                hintText: 'dd/mm/yyyy',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.newStartDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'When will the project start ?',
                                hintText: 'dd/mm/yyyy',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.newEndDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () => {
                                        controller.saveNewlyCreatedProject(),
                                        Navigator.pop(context)
                                      },
                                  child: const Text('Create Project')),
                              TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  child: const Text('Cancel'))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          )
                        ],
                      ));
                    },
                    context: context,
                  )
                },
            child: const Icon(Icons.add)));
  }
}
