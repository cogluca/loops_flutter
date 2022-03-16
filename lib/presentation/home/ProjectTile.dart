import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loops/models/Project.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

class ProjectTile extends GetView<HomeController> {
  late final Project project;

  ProjectTile(this.project);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.only(
                top: 36.0, left: 10.0, right: 6.0, bottom: 6.0),
            child: InkWell (
              onDoubleTap: () {
                Get.find<HomeController>()
                    .navigateToBacklog(project.id);
              },
                child: ExpansionTile(
              expandedAlignment: Alignment.centerLeft,
              title: Text('Project: ${project.name}'),
              children: <Widget>[
                Row(children: [
                  Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Start date: ${project.startDate}',
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('End date: ${project.endDate}')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Task completed: ${project.taskCompleted.toString()}')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Task to do: ${project.taskToDo.toString()}',
                        )),
                  ]),
                  const SizedBox(
                    width: 100,
                  ),
                ])
              ],
            ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ));

    throw UnimplementedError();
  }
}
