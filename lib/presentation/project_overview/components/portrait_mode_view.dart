import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loops/presentation/general_components/scroll_speed.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';

import '../../../model/Sprint.dart';
import 'bar_chart.dart';

class PortraitMode extends GetView<ProjectOverviewController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
            child: StreamBuilder<List<Sprint>>(
                initialData: controller.dataFromSprints,
                stream: controller.retrieveSprints(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Sprint>> dataSnapshot) {
                  if (dataSnapshot.connectionState != ConnectionState.waiting) {
                    return Card(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: BarChartSample2(dataSnapshot.data!)));
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
                        return Wrap(children: [
                          Column(children: [
                            const SizedBox(
                              height: 25,
                            ),
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
                                  if (pickedDay.length > 1) {
                                    controller.sprintStartDate.text +=
                                        '${pickedDate.day}';
                                  } else {
                                    controller.sprintStartDate.text +=
                                        '0${pickedDate.day}';
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
                                  if (pickedDay.length > 1) {
                                    controller.sprintEndDate.text +=
                                        '${pickedDate.day}';
                                  } else {
                                    controller.sprintEndDate.text +=
                                        '0${pickedDate.day}';
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
                            const SizedBox(
                              height: 25,
                            ),
                          ])
                        ]);
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
    );
  }
}
