import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model/Project.dart';
import 'package:loops/presentation/general_components/left_drag_drawer.dart';
import 'package:loops/presentation/home/project_tile.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(onPressed: () => {}, icon: const Icon(Icons.add_alert)),
          ],
        ),
        drawer: LeftDragDrawer(),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<List<Project>>(
                  stream: homeController.getProjects(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Project>> response) {
                    //does a get builder have a size constraint ?
                    return GetBuilder<HomeController>(
                        init: Get.find<HomeController>(),
                        builder: (value) {
                          if (response.hasData) {
                            return ListView.builder(
                                itemCount: response.data?.length,
                                itemBuilder: (context, int index) {
                                  return ProjectTile(response.data![index]);
                                });
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed('/project_creation'),

            child: const Icon(Icons.add)));
  }
}
