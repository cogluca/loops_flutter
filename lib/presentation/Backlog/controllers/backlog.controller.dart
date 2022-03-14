import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/models/Project.dart';
import 'package:loops/presentation/Backlog/repository/backlog_repository.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

import '../../../models/Task.dart';

class BacklogController extends GetxController {

  BacklogRepository backlogRepository = BacklogRepository();
  List<Task> listOfProjectTasks = <Task>[];

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


  Future<List<Task>> retrieveTasksOfProject() async {

    int projectId = Get.find<HomeController>().currentProjectId;

    List<Task> tasksOfCurrentProject = await backlogRepository.retrieveTasks(projectId);
    listOfProjectTasks = await backlogRepository.retrieveTasks(projectId);

    return tasksOfCurrentProject;

  }




}
