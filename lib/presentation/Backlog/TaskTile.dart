import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loops/models/Task.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

class TaskTile extends GetView<HomeController> {
  late final Task task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.only(
                top: 36.0, left: 10.0, right: 6.0, bottom: 6.0),
            child: ExpansionTile(
              expandedAlignment: Alignment.centerLeft,
              title: Text('Task: ${task.name}'),
              children: <Widget>[
                Row(children: [
                  Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Project id: ${task.projectId.toString()}',
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Epic: ${task.epicId.toString()}')), //TODO need to retrieve epic name if it exists, calling a repository from another repository seems bad practice, too strange of a coupling, maybe adding a service locator pattern
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Team Id: ${task.teamId.toString()}')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Team Member Id: ${task.teamMemberId.toString()}',
                        )),
                  ]),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          //TODO plans are to have a card that blurs the background and imposes itself on the screen
                        },
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                        iconSize: 40,
                      )
                    ],
                  )
                ])
              ],
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ));

    throw UnimplementedError();
  }
}