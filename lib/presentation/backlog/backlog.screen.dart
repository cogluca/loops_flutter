import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/Backlog/components/task_tile.dart';
import 'package:loops/presentation/general_components/left_drag_drawer.dart';
import 'package:loops/presentation/general_components/task_creation_dialog.dart';
import 'package:loops/presentation/project_overview/components/meet_dialog.dart';

import '../../model/Task.dart';
import '../home/controllers/home.controller.dart';
import './components/list_builder.dart';
import 'controllers/backlog.controller.dart';

class BacklogScreen extends GetView<BacklogController> {
  String dropDownValue = '';
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext aContext) {
    Get.find<GetStorage>().write('taskLongPressed', false);

    return Scaffold(

      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: const Text('Backlog'),
          centerTitle: true,

          actions:[
                  IconButton(
                      onPressed: () {
                      Builder(builder: (context)
                          {Scaffold.of(aContext).openEndDrawer();
                      return Container(

                      );});},
                      icon: const Icon(Icons.more_vert_outlined)),
          ]),
      endDrawer: MeetDialog(),
      endDrawerEnableOpenDragGesture: true,
      drawer: LeftDragDrawer(),
      body: MediaQuery.of(aContext).orientation == Orientation.portrait
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
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
                Expanded(
                    child: Row(children: [
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
                  Get.offAllNamed('project-overview');
                },
                icon: const Icon(
                  Icons.home,
                  size: 26,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {Get.toNamed('/task_creation')},
          child: const Icon(Icons.add)),
    );
  }
}
