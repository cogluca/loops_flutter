import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';

import '../../../model/Sprint.dart';
import '../../../utils/DateFormatter.dart';
import '../../general_components/scroll_speed.dart';
import 'bar_chart.dart';

class LandscapeMode extends GetView<ProjectOverviewController> {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          flex: 1,
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


                          child: VelocityGraph(dataSnapshot.data!));
                }
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

                        String fromContextProjectStartDate =
                        Get.find<GetStorage>().read('projectStartDate');
                        DateTime projectStartConstraint =
                        DateTime.parse(fromContextProjectStartDate);

                        String fromContextProjectEndDate =
                        Get.find<GetStorage>().read('projectEndDate');
                        DateTime projectEndConstraint =
                        DateTime.parse(fromContextProjectEndDate);

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
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: projectStartConstraint,
                                    lastDate: projectEndConstraint);
                                controller.sprintStartDate.text = DateFormatter
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
                                controller.sprintEndDate.text =
                                    DateFormatter
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
    ]);
  }
}
