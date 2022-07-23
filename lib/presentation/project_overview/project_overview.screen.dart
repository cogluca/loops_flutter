import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/general_components/left_drag_drawer.dart';
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
import 'package:get/get.dart';

class ProjectOverviewScreen extends GetView<ProjectOverviewController> {
  dynamic projectData = Get.parameters;

  static final GlobalKey<ScaffoldState> _scaffoldKeyProject = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    Map projectArgument = Get.parameters;
    print(projectArgument.toString());

    Get.find<GetStorage>().write('projectGoal', projectData['projectGoal']);

    String projectName = Get.find<GetStorage>().read('choosenProjectName');


    return Scaffold(
      key: _scaffoldKeyProject,
      appBar: AppBar(
        title: Text(projectName),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () => {_scaffoldKeyProject.currentState!.openEndDrawer()},
              icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      drawer: LeftDragDrawer(),
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
                  Get.offAllNamed('/backlog');
                },
                icon: const Icon(
                  Icons.book,
                  size: 24,
                )),
            IconButton(
                onPressed: () {
                  Get.offAllNamed('/project-overview');
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
