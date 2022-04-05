import 'package:get/get.dart';

import '../../../../presentation/project_overview/controllers/project_overview.controller.dart';

class ProjectOverviewControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectOverviewController>(
      () => ProjectOverviewController(),
    );
  }
}
