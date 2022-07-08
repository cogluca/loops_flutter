import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/general_components/scroll_speed.dart';
import 'package:loops/presentation/project_overview/components/landscape_mode_view.dart';
import 'package:loops/presentation/project_overview/components/meet_dialog.dart';
import 'package:loops/presentation/project_overview/components/portrait_mode_view.dart';
import 'package:loops/presentation/project_overview/components/sprint_dialog.dart';

import '../../model/Project.dart';
import '../../model/Sprint.dart';
import '../home/controllers/home.controller.dart';
import 'components/bar_chart.dart';
import 'controllers/project_overview.controller.dart';

class ProjectOverviewScreen extends GetView<ProjectOverviewController> {
  dynamic projectData = Get.parameters;

  @override
  Widget build(BuildContext context) {
    Map projectArgument = Get.parameters;
    print(projectArgument.toString());

    Get.find<GetStorage>().write('projectGoal', projectData['projectGoal']);

    String projectName = Get.find<GetStorage>().read('choosenProjectName');
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(projectName),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () => {_scaffoldKey.currentState!.openEndDrawer()},
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
              title: const Text('Go to Projects'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                //Get.find<HomeController>().logOut();
                Get.offNamed('/home');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                //Get.find<HomeController>().logOut();
                Get.offNamed('/login');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      endDrawer: MeetDialog(),
      endDrawerEnableOpenDragGesture: true,
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? PortraitMode()
          : LandscapeMode(),
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
    );
  }
}
