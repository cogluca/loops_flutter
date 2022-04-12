import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/Backlog/components/TaskTile.dart';
import 'package:loops/presentation/general_components/task_creation_dialog.dart';
import 'package:loops/presentation/project_overview/components/meet_dialog.dart';

import '../../model/Task.dart';
import '../home/controllers/home.controller.dart';
import './components/list_builder.dart';
import 'controllers/backlog.controller.dart';

class BacklogScreen extends GetView<BacklogController> {
  String dropDownValue = '';

  @override
  Widget build(BuildContext context) {
    Get.find<GetStorage>().write('taskLongPressed', false);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text('Backlog'),
          centerTitle: true,
          actions: Get.find<GetStorage>().read('taskLongPressed')
              ? [
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.close),
                  ),
                  IconButton(
                      onPressed: () => {},
                      icon: const Icon(CupertinoIcons.trash))
                ]
              : [
                  IconButton(
                      onPressed: () =>
                          {_scaffoldKey.currentState!.openEndDrawer()},
                      icon: const Icon(Icons.more_vert_outlined)),
                ]),
      endDrawer: MeetDialog(),
      endDrawerEnableOpenDragGesture: true,
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
              title: const Text('Go to Projects'),
              onTap: () {
                Get.toNamed('/home');
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
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(children: [
              const Padding(
                  padding: EdgeInsets.all(8.00),
                  child: Text(
                    'Current Sprint',
                    style: TextStyle(fontSize: 20),
                  )),
              ListBuilder(
                  taskStream: controller.retrieveCurrentTasksOfSprint()),
              const Padding(
                  padding: EdgeInsets.all(8.00),
                  child: Text(
                    'Complete Backlog',
                    style: TextStyle(fontSize: 20),
                  )),
              ListBuilder(taskStream: controller.retrieveTasksOfProject()),
            ])
      // Or Landscape Mode
          : Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
                  Padding(
                      padding: EdgeInsets.all(8.00),
                      child: Text(
                        'Current Sprint',
                        style: TextStyle(fontSize: 20),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.00),
                      child: Text(
                        'Complete Backlog',
                        style: TextStyle(fontSize: 20),
                      )),
                ]),
                Expanded(child:
                Row(children: [
                  ListBuilder(
                      taskStream: controller.retrieveCurrentTasksOfSprint()),
                  ListBuilder(taskStream: controller.retrieveTasksOfProject()),
                ]))
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed('/backlog');
                },
                icon: const Icon(
                  Icons.book,
                  size: 24,
                )),
            IconButton(
                onPressed: () {
                  Get.toNamed('project-overview');
                },
                icon: const Icon(
                  Icons.home,
                  size: 26,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                 Get.toNamed('/task_creation')},
          child: const Icon(Icons.add)),
    );
  }
}
