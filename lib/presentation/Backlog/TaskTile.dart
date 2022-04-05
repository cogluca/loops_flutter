import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/models/Task.dart';
import 'package:loops/presentation/Backlog/controllers/backlog.controller.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

class TaskTile extends GetView<BacklogController> {
  late final Task task;

  TaskTile(this.task, {Key? key}) : super(key: key);

  //TODO swipe to the right -> setComplete/backgroundGreen/IconCheckmark && swipe to the left -> trash/BackgroundRed/IconTrash, sorry for leaving you this, haven't had a true free day, it's Sunday
  Widget? showRelevantSwipeBackground() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Key key = GlobalKey();
    return Dismissible(
        onDismissed: (DismissDirection dismissDirection) {
          dismissDirection == DismissDirection.endToStart
              ? controller.deleteTask(task.id)
              : controller.markTaskAsCompleted(task.id);
        },
        background: Container(
            color: Colors.green,
            child: const Icon(CupertinoIcons.check_mark_circled_solid)),
        secondaryBackground: Container(
            color: Colors.red, child: const Icon(CupertinoIcons.trash)),
        key: key,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 6.0, left: 10.0, right: 6.0, bottom: 6.0),
                child: InkWell(
                    child: ListTile(
                  onTap: () => {
                    showDialog(
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 40,
                            insetPadding: const EdgeInsets.only(
                                top: 200, bottom: 280, left: 40, right: 40),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      task.name,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      task.fullDescription,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'This task starts:  ${task.startDate}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'This task ends:    ${task.endDate}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'This task is worth ${task.storyPoints.toString()} points',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    )),
                                const Padding(
                                    padding: EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 8),
                                    child: Text(
                                      'This task is currently undertaken by team',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    )),
                              ],
                            ),
                          );
                        },
                        context: context)
                  },
                  title: Text(task.name),
                ))),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )));
  }
}
