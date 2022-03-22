import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loops/presentation/Backlog/TaskTile.dart';

import '../../models/Task.dart';
import '../home/controllers/home.controller.dart';
import 'controllers/backlog.controller.dart';

class BacklogScreen extends GetView<BacklogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Backlog'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () => {}, icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.more_vert_outlined)),
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
                              backgroundImage: NetworkImage(
                                  Get.find<HomeController>().imageUrl.value),
                            ),
                            Text(
                              Get.find<HomeController>().username.value,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              Get.find<HomeController>().emailOnScreen.value,
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
                title: const Text('Logout'),
                onTap: () async {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  await Get.find<HomeController>().logOut();
                  Get.offNamed('/login');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
              child: GetBuilder<BacklogController>(
                  init: Get.find<BacklogController>(),
                  builder: (value) {
                    return ReorderableListView.builder(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Task taskToOrder = Get.find<BacklogController>()
                              .listOfProjectTasks
                              .removeAt(oldIndex);
                          Get.find<BacklogController>()
                              .listOfProjectTasks
                              .insert(newIndex, taskToOrder);
                        },
                        itemCount: Get.find<BacklogController>()
                            .listOfProjectTasks
                            .length,
                        itemBuilder: (context, int index) {
                          GlobalKey globalKey = GlobalKey();
                          return Draggable(
                            feedback: Container(
                              width: 10,
                            ),
                            child: TaskTile(Get.find<BacklogController>()
                                .listOfProjectTasks[index]),
                            key: globalKey,
                          );
                        });
                  }))
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.book)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.check_box)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.timer))
            ],
          ),
        ),
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
                              controller: controller.createdNewTask,
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
                              controller: controller.startDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'When will the project end ?',
                                hintText: 'dd/mm/yyyy',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.endDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'What team is it assigned to ?',
                                hintText: 'dd/mm/yyyy',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.endDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () => {
                                        controller.saveNewlyCreatedTask(),
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
