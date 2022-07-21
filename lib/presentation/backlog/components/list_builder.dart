import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/Task.dart';
import '../../Backlog/components/TaskTile.dart';
import '../controllers/backlog.controller.dart';

class ListBuilder extends GetView<BacklogController> {
  Stream<List<Task>> taskStream;

  ListBuilder({required this.taskStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
        stream: taskStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Task>> dataSnapshot) {
          return Expanded(
              child: GetBuilder<BacklogController>(
                  init: Get.find<BacklogController>(),
                  builder: (value) {
                    if (dataSnapshot.hasData) {
                      return ReorderableListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: dataSnapshot.data!.length,
                        itemBuilder: (context, int index) {
                          Key aKey = ValueKey(dataSnapshot.data![index].id);
                          return TaskTile(dataSnapshot.data![index], aKey);
                        },
                        onReorder: (int oldIndex, int newIndex) async {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = dataSnapshot.data?.removeAt(oldIndex);
                            dataSnapshot.data?.insert(newIndex, item!);
                            await controller.saveNewTaskPositions(dataSnapshot.data!);
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }));
        });
  }
}
