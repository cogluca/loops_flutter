import 'package:get/get.dart';

import '../../../../presentation/Backlog/controllers/backlog.controller.dart';

class TaskViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<BacklogController>();
  }
}