import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/Project.dart';
import '../../models/Sprint.dart';
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
              onPressed: () => {}, icon: const Icon(Icons.notifications)),
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
      endDrawer: Drawer(
        child: ListView(shrinkWrap: true, children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Meet',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Obx(() => DropdownButton<String>(
                  value: controller.meetingType.value,
                  onChanged: (String? newValue) {
                    controller.meetingType.value = newValue!;
                  },
                  items: <String>[
                    'Sprint Planning',
                    'Sprint Retrospective',
                    'Daily Meet',
                    'One-To-One',
                  ]
                      .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              ))
                      .toList(),
                )),
            padding: const EdgeInsets.only(left: 20.0, top: 20),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'What date does the meeting happen ?',
                hintText: 'yyyy/mm/dd',
                border: OutlineInputBorder(),
              ),
              controller: controller.meetingDate,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'When will the meeting start ?',
                hintText: 'e.g 14:30',
                border: OutlineInputBorder(),
              ),
              controller: controller.meetingStartTime,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'When will the meeting end ?',
                hintText: 'e.g 15:00',
                border: OutlineInputBorder(),
              ),
              controller: controller.meetingEndTime,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Who will participate ?',
                hintText: 'List the emails with a ;',
                border: OutlineInputBorder(),
              ),
              controller: controller.emailsOnForm,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Description',
                hintText: 'Brief summary of event',
                border: OutlineInputBorder(),
              ),
              controller: controller.meetingDescription,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'On Google meet ? remote',
                border: OutlineInputBorder(),
              ),
              controller: controller.locationOfMeeting,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: Obx(() => Center(
                    child: SwitchListTile(
                  onChanged: (bool value) {
                    controller.conferenceSupportState.value = value;
                  },
                  value: controller.conferenceSupportState.value,
                  title: const Text('Google Meet'),
                ))),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: Obx(() => Center(
                    child: SwitchListTile(
                  onChanged: (bool value) {
                    controller.notifyAttendantsState.value = value;
                  },
                  value: controller.notifyAttendantsState.value,
                  title: const Text('Notify attendants'),
                ))),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextButton(
              child: const Text('Invite'),
              onPressed: () {
                controller.sendGoogleMeetInvite();
                Navigator.of(context).pop();
                Get.snackbar('Mission accomplished',
                    'Invite sent correctly, check calendar your calendar for the event info');
              },
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
          ),
        ]),
      ),
      endDrawerEnableOpenDragGesture: true,
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          StreamBuilder<List<Sprint>>(
            initialData: controller.dataFromSprints,
            stream: controller.retrieveSprints(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Sprint>> dataSnapshot) {
              return Expanded(
                  child: Card(child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child: BarChartSample2(dataSnapshot.data!))));
            },
          ),
          const Text(
            'Sprint',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() {
                if (controller.currentSprint.isEmpty) {
                  return const Text('None active');
                } else {
                  return Text(
                    'Current Sprint: From ${controller.currentSprint[0].startDate.toString()} To ${controller.currentSprint[0].endDate.toString()} ',
                    style: const TextStyle(fontSize: 15),
                  );
                }
              }),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
                child: TextButton(
              onPressed: () {
                showDialog(
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.only(
                            bottom: 400, top: 140, left: 20, right: 20),
                        child: Column(children: [
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Sprint start date',
                                hintText: 'Enter sprint start date',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.sprintStartDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Sprint end date',
                                hintText: 'Enter sprint end date',
                                border: OutlineInputBorder(),
                              ),
                              controller: controller.sprintEndDate,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Card(
                            child: TextButton(
                              child: const Text(
                                'Start Sprint',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                controller.startSprint();
                                Navigator.pop(context);
                              },
                            ),
                            color: Colors.blue,
                          )
                        ]),
                      );
                    },
                    context: context);
              },
              child: const Text('Start a sprint'),
            )),
            Obx(() {
              if (controller.currentSprint.isNotEmpty) {
                return Card(
                    child: TextButton(
                  onPressed: () {
                    controller.turnSprintOff();
                  },
                  child: const Text('End Sprint'),
                ));
              } else {
                return const SizedBox.shrink();
              }
            })
          ]),
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
                icon: const Icon(Icons.book, size: 24,)),
            IconButton(
                onPressed: () {
                  Get.toNamed('project-overview');
                },
                icon: const Icon(Icons.home, size: 26,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.timer, size: 24,))
          ],
        ),
      ),
    );
  }
}
