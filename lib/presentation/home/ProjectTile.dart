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
            child: InkWell(
                onDoubleTap: () {
                  Get.find<HomeController>()
                      .navigateToProjectScreen(project.id!, project.name!, project);
                },
                child: ListTile(
                  title: Text('Project: ${project.name}'),
                  subtitle: Text(project.oneLiner!),
                ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ));

    throw UnimplementedError();
  }
}
