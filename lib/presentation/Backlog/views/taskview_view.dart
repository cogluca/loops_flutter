import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loops/presentation/Backlog/controllers/backlog.controller.dart';

class TaskviewView extends GetView<BacklogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Creation'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 35)),
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
                hintText: 'yyyy/mm/dd',
                border: OutlineInputBorder(),
              ),
              controller: controller.startDate,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2025));
                controller.startDate.text = '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
              },
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'When will the task end ?',
                hintText: 'yyyy/mm/dd',
                border: OutlineInputBorder(),
              ),
              controller: controller.endDate,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2025));
                controller.endDate.text = '${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}';
              },
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
      )
    );
  }
}
