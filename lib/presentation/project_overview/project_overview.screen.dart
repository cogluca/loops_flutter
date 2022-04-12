import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/general_components/scroll_speed.dart';
import 'package:loops/presentation/project_overview/components/meet_dialog.dart';
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
          ? Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                    child: StreamBuilder<List<Sprint>>(
                        initialData: controller.dataFromSprints,
                        stream: controller.retrieveSprints(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Sprint>> dataSnapshot) {
                          if (dataSnapshot.connectionState !=
                              ConnectionState.waiting) {
                            return Card(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child:
                                        BarChartSample2(dataSnapshot.data!)));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
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
                  Obx(() {
                    if (controller.currentSprint.isEmpty) {
                      return Card(
                          child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(children: [Column(children: [
                                  const SizedBox(height: 25,),
                                  Container(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Sprint start date',
                                        hintText: 'Enter sprint start date',
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: controller.sprintStartDate,
                                      onTap: () async {
                                        String pickedMonth = '';
                                        String pickedDay = '';
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.utc(2050));
                                        pickedMonth = pickedDate!.month.toString();
                                        pickedDay = pickedDate.day.toString();
                                        if (pickedMonth.length > 1) {
                                          controller.sprintStartDate.text =
                                          '${pickedDate.year}-${pickedDate.month}-';
                                        } else {
                                          controller.sprintStartDate.text =
                                          '${pickedDate.year}-0${pickedDate.month}-';
                                        }
                                        if(pickedDay.length > 1){
                                          controller.sprintStartDate.text += '${pickedDate.day}';
                                        }
                                        else{
                                          controller.sprintStartDate.text += '0${pickedDate.day}';
                                        }
                                      },
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
                                      onTap: () async {
                                        String pickedMonth = '';
                                        String pickedDay = '';
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.utc(2050));
                                        pickedMonth = pickedDate!.month.toString();
                                        pickedDay = pickedDate!.day.toString();
                                        if (pickedMonth.length > 1) {
                                          controller.sprintEndDate.text =
                                          '${pickedDate.year}-${pickedDate.month}-';
                                        } else {
                                          controller.sprintEndDate.text =
                                          '${pickedDate.year}-0${pickedDate.month}-';
                                        }
                                        if(pickedDay.length > 1){
                                          controller.sprintEndDate.text += '${pickedDate.day}';
                                        }
                                        else{
                                          controller.sprintEndDate.text += '0${pickedDate.day}';
                                        }
                                      },
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
                                  ),
                                  const SizedBox(height: 25,),
                                ])]);
                              });
                        },
                        child: const Text('Start a sprint'),
                      ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
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
            )
          : Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                  flex: 1,
                  child: StreamBuilder<List<Sprint>>(
                    initialData: controller.dataFromSprints,
                    stream: controller.retrieveSprints(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Sprint>> dataSnapshot) {
                      if (dataSnapshot.connectionState !=
                          ConnectionState.waiting) {
                        return Card(
                            child: SingleChildScrollView(
                                controller: AdjustableScrollController(20),
                                scrollDirection: Axis.horizontal,
                                child: BarChartSample2(dataSnapshot.data!)));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Current Sprint: '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() {
                        if (controller.currentSprint.isEmpty) {
                          return const Text('None active');
                        } else {
                          return Text(
                            'From ${controller.currentSprint[0].startDate.toString()} To ${controller.currentSprint[0].endDate.toString()} ',
                            style: const TextStyle(fontSize: 15),
                          );
                        }
                      }),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 39),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(children: [
                                  Container(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Sprint start date',
                                        hintText: 'Enter sprint start date',
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: controller.sprintStartDate,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2025));
                                        controller.sprintStartDate.text = '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
                                      },
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
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2025));
                                        controller.sprintEndDate.text = '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
                                      },
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
                                ]);
                              });
                        },
                        child: const Text('Create a sprint'),
                      )),
                    ],
                  ),
                  Row(
                    children: [
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
                    ],
                  )
                ],
              )
            ]),
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
