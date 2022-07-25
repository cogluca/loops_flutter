import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loops/model/Project.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

class ProjectTile extends GetView<HomeController> {
  late final Project project;

  ProjectTile(this.project);

  @override
  Widget build(BuildContext context) {
    Key aKey = ValueKey(project.id);

    return Dismissible(
        onDismissed: (DismissDirection dismissDirection) {
          dismissDirection == DismissDirection.endToStart
              ? controller.deleteProject(project.id)
              : controller.markProjectAsCompleted(project.id);
        },
        background: Container(
            color: Colors.green,
            child: const Icon(CupertinoIcons.check_mark_circled_solid)),
        secondaryBackground: Container(
            color: Colors.red, child: const Icon(CupertinoIcons.trash)),

        key: aKey,


      child: Card(
        child: Padding(
            padding: const EdgeInsets.only(
                top: 36.0, left: 10.0, right: 6.0, bottom: 6.0),
            child: InkWell(
                onDoubleTap: () {
                  controller
                      .navigateToProjectScreen(project);
                },
                child: ListTile(
                  title: Text('Project: ${project.name}'),
                  subtitle: Text(project.oneLiner),
                ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        )));

    throw UnimplementedError();
  }
}
