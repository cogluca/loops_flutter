import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/models/Project.dart';
import 'package:loops/presentation/Backlog/repository/backlog_repository.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

import '../../../models/Task.dart';

class BacklogController extends GetxController {

  BacklogRepository backlogRepository = BacklogRepository();
  RxList<Task> listOfProjectTasks = <Task>[].obs;

  TextEditingController createdNewTask = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();



  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    retrieveTasksOfProject();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}


  Future<void> retrieveTasksOfProject() async {

    String projectId = Get.find<HomeController>().currentProjectId;

    List<Task> tasksOfCurrentProject = await backlogRepository.retrieveTasks(projectId);
    List<Task> computedTasks= await backlogRepository.retrieveTasks(projectId);
    listOfProjectTasks.addAll(computedTasks);

    update();

  }

  Future<void> saveNewlyCreatedTask() async {

    String projectId = Get.find<HomeController>().currentProjectId;

    await backlogRepository.addNewTask(projectId, createdNewTask.text, startDate.text, endDate.text);





  }




}
