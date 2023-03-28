import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/general_components/scroll_speed.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';

import '../../../model/Sprint.dart';
import '../../../utils/DateFormatter.dart';
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
                    if (!dataSnapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'No Sprints currently active, start one !',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 50,
                            color: Colors.amber,
                          )
                        ],
                      );
                    } else {

                      return Card(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: VelocityGraph(dataSnapshot.data!)));
                    }
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
                return const Text('None active',
                );
              } else {
                return Text(
                  'Current Sprint: From ${controller.currentSprint[0].startDate.toString()} To ${controller.currentSprint[0].endDate.toString()} ',
                  style: const TextStyle(fontSize: 15, ),
                );
              }
            }),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Obx(() {
            if (controller.currentSprint.isEmpty) {
              return Card(
                margin: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                color: const Color(0xFFf5d271),
                  child: TextButton(
                      style:
                      TextButton.styleFrom(backgroundColor: const Color(0xFFf5d271)),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        String fromContextProjectStartDate =
                            Get.find<GetStorage>().read('projectStartDate');
                        DateTime projectStartConstraint =
                            DateTime.parse(fromContextProjectStartDate);

                        String fromContextProjectEndDate =
                            Get.find<GetStorage>().read('projectEndDate');
                        DateTime projectEndConstraint =
                            DateTime.parse(fromContextProjectEndDate);

                        return Wrap(children: [ Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10
                        )
                            ,child:
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
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: projectStartConstraint,
                                      lastDate: projectEndConstraint);
                                  controller.sprintStartDate.text =
                                      DateFormatter
                                          .fromDateTimeToIntendedFormat(
                                              pickedDate!);
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
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: projectStartConstraint,
                                      lastDate: projectEndConstraint);

                                  controller.sprintEndDate.text = DateFormatter
                                      .fromDateTimeToIntendedFormat(
                                          pickedDate!);
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
                        )]);
                      });
                },
                child: const Text('Start a sprint', style: TextStyle(
                    color: Color(0xFFad7f00),),
    )));
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
                child: const Text('End Sprint', style: TextStyle(
                    color: Color(0xFFad7f00),),
              )));
            } else {
              return const SizedBox.shrink();
            }
          })
        ]),
      ],
    );
  }
}
