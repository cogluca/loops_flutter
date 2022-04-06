import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/transcoder/v1.dart';
import 'package:loops/presentation/Backlog/components/TaskTile.dart';
import 'package:loops/presentation/ui_components.dart';

import '../../models/Task.dart';
import '../home/controllers/home.controller.dart';
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
                      onPressed: () => {},
                      icon: const Icon(Icons.notifications)),
                  IconButton(
                      onPressed: () =>
                          {_scaffoldKey.currentState!.openEndDrawer()},
                      icon: const Icon(Icons.more_vert_outlined)),
                ]),
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
      body: Column(children: [
        const Padding(
            padding: EdgeInsets.all(8.00),
            child: Text(
              'Current Sprint',
              style: TextStyle(fontSize: 20),
            )),
        StreamBuilder<List<Task>>(
            stream: controller.retrieveCurrentTasksOfSprint(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> dataSnapshot) {
              return Expanded(
                  child: GetBuilder<BacklogController>(
                      init: Get.find<BacklogController>(),
                      builder: (value) {
                        if (dataSnapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataSnapshot.data!.length,
                              itemBuilder: (context, int index) {
                                return TaskTile(dataSnapshot.data![index]);
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }));
            }),
        const Padding(
            padding: EdgeInsets.all(8.00),
            child: Text(
              'Complete Backlog',
              style: TextStyle(fontSize: 20),
            )),

        StreamBuilder<List<Task>>(
            stream: controller.retrieveTasksOfProject(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> dataSnapshot) {
              return Expanded(
                  child: GetBuilder<BacklogController>(
                      init: Get.find<BacklogController>(),
                      builder: (value) {
                        if (dataSnapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataSnapshot.data!.length,
                              itemBuilder: (context, int index) {
                                return TaskTile(dataSnapshot.data![index]);
                              });
                        } else if(dataSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return const Card(child: Text('Nothing in here'),);
                        }
                      }));
            }),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed('/backlog');
                },
                icon: const Icon(Icons.book)),
            IconButton(
                onPressed: () {
                  Get.toNamed('project-overview');
                },
                icon: const Icon(Icons.home)),
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
                              labelText: 'Task name',
                              hintText: 'Enter task name',
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.createdNewTask,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'When will the task start ?',
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
                              labelText: 'When will the task end ?',
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
                              hintText: 'team color',
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.teamAssigned,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'One liner description',
                              hintText: 'Ipsum dolor',
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.oneLiner,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full description',
                              hintText: 'Ipsum dolor',
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.fullDescription,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Story points',
                              hintText: 'How many points is it worth ?',
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.storyPoints,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Container(
                          child: Obx(() => Center(
                                  child: SwitchListTile(
                                onChanged: (bool value) {
                                  controller.assignToSprintState.value = value;
                                },
                                value: controller.assignToSprintState.value,
                                title: const Text('Add to Sprint'),
                              ))),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () => {
                                      controller.saveNewlyCreatedTask(),
                                      Navigator.pop(context)
                                    },
                                child: const Text('Create Task')),
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
          child: const Icon(Icons.add)),
    );
  }
}
