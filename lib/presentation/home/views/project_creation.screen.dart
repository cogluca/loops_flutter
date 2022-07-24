import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';
import 'package:loops/utils/DateFormatter.dart';


class ProjectCreationScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Project Creation'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(child: Container(
            padding: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10
            ), child:
        Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 35)),
            Container(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Project name',
                  hintText: 'Enter project name',
                  border: OutlineInputBorder(),
                ),
                controller: controller.createdNewProject,
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
                  labelText: 'When will the project start ?',
                  hintText: 'yyyy/mm/dd',
                  border: OutlineInputBorder(),
                ),
                controller: controller.newStartDate,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.utc(2025));
                  controller.newStartDate.text = DateFormatter.fromDateTimeToIntendedFormat(pickedDate!);
                },
              ),
              padding: const EdgeInsets.all(8.0),
            ),

            Container(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'When will the project end ?',
                  hintText: 'yyyy/mm/dd',
                  border: OutlineInputBorder(),
                ),
                controller: controller.newEndDate,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.utc(2025));
                  controller.newEndDate.text = DateFormatter.fromDateTimeToIntendedFormat(pickedDate!);
                },
              ),
              padding: const EdgeInsets.all(8.0),
            ),

            Container(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Project Goal',
                  hintText: 'Ipsum dolor',
                  border: OutlineInputBorder(),
                ),
                controller: controller.projectGoal,
              ),
              padding: const EdgeInsets.all(8.0),
            ),

            Row(
              children: [
                TextButton(
                    onPressed: () => {
                          controller.saveNewlyCreatedProject(),
                          Navigator.pop(context)
                        },
                    child: const Text('Create Project')),
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Cancel'))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
        ))));
  }
}
