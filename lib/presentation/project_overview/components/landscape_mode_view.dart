import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';

import '../../../model/Sprint.dart';
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
                return Card(
                    child: SingleChildScrollView(
                        controller: AdjustableScrollController(200),
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
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.utc(2025));
                                controller.sprintStartDate.text =
                                    '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
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
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.utc(2025));
                                controller.sprintEndDate.text =
                                    '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
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
